# Script to generate statin quantities

library(tidyverse)
library(odbc)
library(dbplyr)
library(dplyr)
library(lubridate)
library(data.table)

setwd("~/ccu014")

count.medicine.type <- function(pis, year, month, type) {
  total <- pis %>% 
    summarise(count = n(), average_quantity = mean(quantity, na.rm = T), total_quantity = sum(quantity, na.rm = T), missing_quantity = sum(is.na(quantity))) %>%
    mutate(year = year, 
           month = month, type = type) %>%
    select(year, month, type, count, average_quantity, total_quantity, missing_quantity)
  
  total
}

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
# Very rarely an ID will have 2 dates of death.
# These are usually recent deaths
death.duplicate <- deaths %>% group_by(anon_id) %>% summarise(n = n())%>%
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

if (any(death.duplicate$n > 1)) { stop("Duplicate death anon_id")}

tre <- read.csv("tre_bnf_codes_all.csv", as.is = TRUE)

tre.atorvastatin <- tre %>% filter(BNF_PRESENTATION == "Atorvastatin 40mg tablets")
tre.simvastatin <- tre %>% filter(BNF_PRESENTATION == "Simvastatin 40mg tablets")

statins <- c(tre.atorvastatin$BNFCode, tre.simvastatin$BNFCode)

count.by.month.year <- data.frame(
  year = c(2018, 2019, 2020, 2021), 
  start = c(3,1,1,1), 
  end = c(12, 12, 12, 11))

l.statin <- list()
for (i in 1:nrow(count.by.month.year)) {
  year <- count.by.month.year[i,]$year
  dispensed.year = dispensed %>%
    select(anon_id, 
           hbres_2006,
           bnf_chapter_code, 
           bnf_code,
           dispensed_date, 
           age_at_dispensed_date,
           quantity) %>%
    filter(year(dispensed_date) == year &
             bnf_code %in% statins) %>%
    as.data.table()
  
  z.cnt <- nrow(dispensed.year)
  
  # Only include prescriptions from Scotland
  z <- dispensed.year %>% filter(hbres_2006 %in% c("S08200001", "S08200004"))
  pis <- dispensed.year %>% filter(!(hbres_2006 %in% c("S08200001", "S08200004")))
  if (nrow(pis) + nrow(z) != z.cnt) { stop("Error removing oustside Scotland HBs")}
  
  # Patients alive on or after 01/03/2018
  pis <- merge(pis, deaths, "anon_id", all.x = TRUE)
  print(nrow(pis))
  z.cnt <- nrow(pis)
  dead <- pis %>% filter(date_of_death < "2018-03-01")
  
  pis <- pis %>% filter(is.na(date_of_death) |
                          date_of_death >= "2018-03-01")
  nrow(pis)
  if (nrow(dead) + nrow(pis) != z.cnt) { stop("Dead count mismatch")}

  # Age restricted
  pis <- pis %>% 
    filter(age_at_dispensed_date >= 18 & age_at_dispensed_date < 112)
  print(nrow(pis))
  
  # Include chapters 1 - 15 only
  pis <- pis %>% filter(bnf_chapter_code %in% sprintf("%0.2d", 1:15))
  print(sort(unique(pis$bnf_chapter_code)))
  print(nrow(pis))
  
  for (m in (count.by.month.year[i,]$start):(count.by.month.year[i,]$end)) {
    pis.m <- pis %>% filter(month(dispensed_date) == m)
    
    # Atorvastatin
    pis.atorvastatin <- pis.m %>% filter(bnf_code %in% tre.atorvastatin$BNFCode)
    atorva.count <- count.medicine.type(pis.atorvastatin, year, m, "atorvastatin")

    # Simvastatin
    pis.simvastatin <- pis.m %>% filter(bnf_code %in% tre.simvastatin$BNFCode)
    simva.count <- count.medicine.type(pis.simvastatin, year, m, "simvastatin")
  
    l.statin[[length(l.statin) + 1]]  <- list(atorva.count, simva.count)
  }
  rm(dispensed.year)
  gc()
}                   

# Atorvastatin
l.atorvastatin <- lapply(l.statin, function(x) x[[1]])
atorvastatin <- do.call(rbind, l.atorvastatin)

# Simvastatin
l.simvastatin <- lapply(l.statin, function(x) x[[2]])
simvastatin <- do.call(rbind, l.simvastatin)

write.csv(x = atorvastatin, file = "raw/atorvastatin.csv")
write.csv(x = simvastatin, file = "raw/simvastatin.csv")


t2 <- Sys.time()
print(t2 - t1)

odbc::dbDisconnect(con_rdb)
