# Script to generate the dispensed cohort.

library(tidyverse)
library(odbc)
library(dbplyr)
library(dplyr)
library(lubridate)
library(data.table)

setwd("~/ccu014")
source("~/ccu014/ccu014_fns_dispensed.r")

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
death.duplicate <- deaths %>% group_by(anon_id) %>% summarise(n = n())
if (any(death.duplicate$n > 1)) { stop("Duplicate death anon_id")}

tre <- read.csv("tre_bnf_codes_all.csv", as.is = TRUE)
tre.subgrps <- tre %>% filter(key_group != "")
tre.both <- read.csv("tre_bnf_codes_in_both.csv")

count.by.month.year <- data.frame(
  year = c(2018, 2019, 2020, 2021), 
  start = c(3,1,1,1), 
  end = c(12, 12, 12, 9))

#cnt1 <- count.medicines(dispensed, deaths, tre.subgrps, year = 2021, month = 4)
list.all.counts <- list()

for (i in 1:nrow(count.by.month.year)) {
  year <- count.by.month.year[i,]$year
  dispensed.year = dispensed %>%
    select(anon_id, date_of_birth, sex, hbres_2006,
           bnf_chapter_code, bnf_code,
           prescribed_date, dispensed_date, age_at_dispensed_date,
           paid_date, 
           bnf_item_description, prescribable_item_name) %>%
    filter(year(dispensed_date) == year) %>%
    as.data.table()
  
  for (m in (count.by.month.year[i,]$start):(count.by.month.year[i,]$end)) {
    l <- count.medicines(dispensed.year, deaths, tre.both, tre.subgrps, year, m)  
    list.all.counts[[length(list.all.counts) + 1]] <- l
  }
  rm(dispensed.year)
  gc()
}                   

# All counts
l.med.cnts <- lapply(list.all.counts, function(x) x[[1]])
med.cnts <- do.call(rbind, l.med.cnts)

all.meds <- med.cnts %>% filter(key_group == "all")
both.meds <- med.cnts %>% filter(key_group == "both")
cvd.meds <- med.cnts %>% filter(key_group == "cvd")
subgrp.meds <- med.cnts %>% filter(key_group %in% unique(tre.subgrps$key_group))

if (nrow(med.cnts) != nrow(all.meds) + nrow(both.meds) + nrow(cvd.meds) + nrow(subgrp.meds)) { stop("Error subgrouping meds") }

# Process the incident medicnes
l.monthly.incident.med.cnts <- lapply(list.all.counts, function(x) x[[2]])
monthly.incident.med.cnts <- do.call(rbind, l.monthly.incident.med.cnts)

# Get the earliest occurrence of each medicine type by anon_id
incident.meds = monthly.incident.med.cnts %>% group_by(anon_id, key_group) %>%
  mutate(rank = row_number(dispensed_date)) %>%
  filter(rank == 1) %>%
  ungroup()

# RC (09/11/2021) This is incorrect in that it's just a summation of 
# the categories rather than a real incidence count of CVDs
#total.incidence.by.month <- incident.meds %>% group_by(year, month) %>%
#  count() %>%
#  mutate(key_group = "cvd") %>%
#  select(year, month, key_group, n)
subgrp.incidence.by.month <- incident.meds %>% group_by(year, month, key_group) %>%
  count()

#incidence.by.month <- rbind(total.incidence.by.month, subgrp.incidence.by.month)
incidence.by.month <- subgrp.incidence.by.month

# Write out the raw data - before further processing.
#write.csv(x = med.cnts,file = "raw1/med.cnts_raw.csv")
#write.csv(x = monthly.incident.med.cnts,"raw1/monthly.incident.med.cnts_raw.csv")
#write.csv(x = incident.meds,file = "raw1/incident.meds_raw.csv")

# Write out the raw output files
# write.csv(x = population,file = "raw1_age_at_dispense/population.csv")
write.csv(x = all.meds, file = "raw/all_dispensed.csv")
write.csv(x = both.meds, file = "raw/both_dispensed.csv")
write.csv(x = cvd.meds, file = "raw/cvd_dispensed.csv")
write.csv(x = subgrp.meds, file = "raw/subgrp_dispensed.csv")
write.csv(x = incidence.by.month, file = "raw/incidence_dispensed.csv")

t2 <- Sys.time()
print(t2 - t1)

odbc::dbDisconnect(con_rdb)
