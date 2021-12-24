# Script to generate the dispensed cohort population.

library(tidyverse)
library(odbc)
library(dbplyr)
library(dplyr)
library(lubridate)
library(data.table)

setwd("~/ccu014")

con_rdb <- suppressWarnings(
  odbc::dbConnect(RPostgreSQL::PostgreSQL(),
                  dbname = "",
                  host = "",
                  port = "",
                  user = "",
                  password = ""))

t1 <- Sys.time()

dispensed <- tbl(con_rdb, in_schema("project_2021_0102", "dispensed"))
deaths_d <- tbl(con_rdb, in_schema("project_2021_0102", "deaths"))
deaths <- deaths_d %>% select(anon_id, date_of_death) %>% 
  distinct() %>%
  as.data.table()

print(sprintf("Total deaths: %s", nrow(deaths)))
# Very rarely an ID will have 2 dates of death.
# These are usually recent deaths
death.duplicate <- deaths %>% group_by(anon_id) %>% summarise(n = n()) %>%
  filter(n > 1)

print(death.duplicate$anon_id)

if (nrow(death.duplicate) > 0) {
  # Remove an duplicates beyond 01/03/2018
  dup.ids <- death.duplicate %>% select(anon_id)
  
  remove <- deaths %>% 
    filter(anon_id %in% dup.ids$anon_id & date_of_death >= "2018-03-01") %>%
    select(anon_id) %>% distinct()
 
  deaths <- deaths %>% filter(!(anon_id %in% remove$anon_id)) 
  death.duplicate <- death.duplicate %>% filter(!(anon_id %in% remove$anon_id)) 
}
print(sprintf("Total deaths (removed duplicates): %s", nrow(deaths)))

if (any(death.duplicate$n > 1)) { stop("Duplicate death anon_id")}

# Populations
start.date <- (c("2018-03-01", "2019-03-01", "2020-03-01", "2021-03-01"))
end.date <- (c("2019-02-28", "2020-02-29", "2021-02-28", "2022-02-28"))

population <- data.frame(start.date = start.date, end.date = end.date, 
                         total = 0, all = 0, both = 0,
                         cvd = 0, cvd.group.a = 0, cvd.group.b = 0,
                         stringsAsFactors = FALSE)

# The medicines
tre <- read.csv("tre_bnf_codes_all.csv", as.is = TRUE)
tre.subgrps <- tre %>% filter(key_group != "")
tre.both <- read.csv("tre_bnf_codes_in_both.csv")
# Groups a and b
cvd.group.a <- c("antihypertensives", "lipid_lowering", 
                 "type_2_diabetes", "insulin")
cvd.group.b <- c("AF", "angina", "heart_failure", 
                 "anticoagulant_warfarins", 
                 "anticoagulants_heparins", "anticoagulant_DOAC", 
                 "antiplatelets_secondary")
tre.subgrps.a <- tre.subgrps %>% filter(key_group %in% cvd.group.a)
tre.subgrps.b <- tre.subgrps %>% filter(key_group %in% cvd.group.b)
if (nrow(tre.subgrps.a) + nrow(tre.subgrps.b) != nrow(tre.subgrps)) {stop("CVD group error")}

for (i in 1:nrow(population)) {
  s <- population[i,]$start.date
  e <- population[i,]$end.date
  pis <- dispensed %>%
      filter(dispensed_date >= s &
               dispensed_date <= e) %>%
    select(anon_id, dispensed_date, age_at_dispensed_date, 
           hbres_2006, bnf_chapter_code, bnf_code) %>%
    as.data.table()
  print(sprintf("Total in PIS (%s - %s): %d", e, s, nrow(pis)))
  print(min(pis$dispensed_date))
  print(max(pis$dispensed_date))
  
  # # Only prescriptions in Scotland
  pis <- pis %>% filter(!(hbres_2006 %in% c("S08200001", "S08200004")))
  print(sprintf("Total after removing non-Scottish prescriptions (%s - %s): %d", s, e, nrow(pis)))

  pis <- merge(pis, deaths, "anon_id", all.x = TRUE)
  print(sprintf("Total in PIS after merging deaths (%s - %s): %d", s, e, nrow(pis)))
  z.cnt <- nrow(pis)
  
  # If you died on the 1st it means you were alive on the 1st
  dead <- pis %>% filter(date_of_death < "2018-03-01")

  pis <- pis %>% filter(is.na(date_of_death) |
                          date_of_death >= "2018-03-01")

  if (nrow(dead) + nrow(pis) != z.cnt) { stop("Dead count mismatch - population")}
  print(sprintf("Total after removing deaths (%s - %s): %d", s, e, nrow(pis)))
  
  # Age restricted
  pis <- pis %>% 
    filter(age_at_dispensed_date >= 18 & age_at_dispensed_date < 112)
  
  # BNF 1-15
  pis <- pis %>% filter(bnf_chapter_code %in% sprintf("%0.2d", 1:15))
  
  #
  print(sprintf("Total for pop. count (%s - %s): %d", s, e, nrow(pis)))
  
  # Total medicines (every medicine recorded in BNF 1 - 15)
  population[i,]$total = length(unique(pis$anon_id))
  
  # "All" medicines (English TRE medicines)
  pis.all <- pis %>% filter(bnf_code %in% tre$BNFCode)
  population[i,]$all = length(unique(pis.all$anon_id))
  
  # Both medicines
  pis.both <- pis %>% filter(bnf_code %in% tre.both$BNFCode)
  population[i,]$both = length(unique(pis.both$anon_id))
  
  # CVD medicines
  pis.cvd <- pis %>% filter(bnf_code %in% tre.subgrps$BNFCode)
  population[i,]$cvd = length(unique(pis.cvd$anon_id))
  
  # Group A medicines
  pis.cvd.a <- pis %>% filter(bnf_code %in% tre.subgrps.a$BNFCode)
  population[i,]$cvd.group.a = length(unique(pis.cvd.a$anon_id))
  
  # Group B medicines
  pis.cvd.b <- pis %>% filter(bnf_code %in% tre.subgrps.b$BNFCode)
  population[i,]$cvd.group.b = length(unique(pis.cvd.b$anon_id))
}

write.csv(x = population,file = "raw/population_dispensed.csv")
t2 <- Sys.time()
print(t2 - t1)

odbc::dbDisconnect(con_rdb)
