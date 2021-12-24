count.medicines <- function(dispensed, deaths, tre.both, tre.subgrps, year, month) {

  pis = dispensed %>%
    select(anon_id, date_of_birth, sex, hbres_2006,
           bnf_chapter_code, bnf_code,
           prescribed_date, dispensed_date, age_at_dispensed_date,
           paid_date, 
           bnf_item_description, prescribable_item_name) %>%
    filter(year(dispensed_date) == year & month(dispensed_date) == month) %>%
    as.data.table()
  z.cnt <- nrow(pis)
  print(z.cnt)
  
  # Only include prescriptions  from Scotland
  z <- pis %>% filter(hbres_2006 %in% c("S08200001", "S08200004"))
  pis <- pis %>% filter(!(hbres_2006 %in% c("S08200001", "S08200004")))
  if (nrow(pis) + nrow(z) != z.cnt) { stop("Error removing oustside Scotland HBs")}
  
  print(unique(pis$hbres_2006))
  
  # Patients alive on or after 01/03/2018
  pis <- merge(pis, deaths, "anon_id", all.x = TRUE)
  print(nrow(pis))
  z.cnt <- nrow(pis)
  dead <- pis %>% filter(date_of_death < "2018-03-01")

  pis <- pis %>% filter(is.na(date_of_death) |
                          date_of_death >= "2018-03-01")
  nrow(pis)
  if (nrow(dead) + nrow(pis) != z.cnt) { stop("Dead count mismatch")}
    
  # Include chapters 1 - 15 only
  pis <- pis %>% filter(bnf_chapter_code %in% sprintf("%0.2d", 1:15))
  print(sort(unique(pis$bnf_chapter_code)))
  print(nrow(pis))
  
  pis <- pis %>% 
    filter(age_at_dispensed_date >= 18 & age_at_dispensed_date < 112)
  print(nrow(pis))
  
  # Add age categories
  pis <- pis %>% 
    mutate(age_cat1 = case_when(age_at_dispensed_date >= 18 & 
                                  age_at_dispensed_date < 65 ~ "18-64",
                                TRUE ~ "65+"), 
           age_cat2 = case_when(age_at_dispensed_date >= 18 & 
                                  age_at_dispensed_date < 30 ~ "18-29",
                                age_at_dispensed_date >= 30 & 
                                  age_at_dispensed_date < 40 ~ "30-39",
                                age_at_dispensed_date >= 40 & 
                                  age_at_dispensed_date < 50 ~ "40-49",
                                age_at_dispensed_date >= 50 & 
                                  age_at_dispensed_date < 60 ~ "50-59",
                                age_at_dispensed_date >= 60 & 
                                  age_at_dispensed_date < 70 ~ "60-69",
                                age_at_dispensed_date >= 70 & 
                                  age_at_dispensed_date < 80 ~ "70-79",
                                age_at_dispensed_date >= 80 & 
                                  age_at_dispensed_date < 90 ~ "80-89",
                                TRUE ~ "90+"))
  
  # Counts 
  all.counts <- NA
  # All medicines
  total <- count.total(pis, "all", year, month)
  total.sex <- count.by.sex(pis, "all", year, month)  
  total.age.cat1 <- count.by.age.cat1(pis, "all", year, month)
  total.age.cat2 <- count.by.age.cat2(pis, "all", year, month)  
  total.hbres_2006 <- count.by.hbres_2006(pis, "all", year, month)

  all.counts <- rbind(total, total.sex, total.age.cat1, 
                      total.age.cat2, total.hbres_2006)
  
  # Both
  both.counts <- NA
  pis.both <- pis %>% filter(bnf_code %in% tre.both$BNFCode)
  nrow(pis.both)
  total.both <- count.total(pis.both, "both", year, month)
  total.both.sex <- count.by.sex(pis.both, "both", year, month)  
  total.both.age.cat1 <- count.by.age.cat1(pis.both, "both", year, month)
  total.both.age.cat2 <- count.by.age.cat2(pis.both, "both", year, month)  
  total.both.hbres_2006 <- count.by.hbres_2006(pis.both, "both", year, month)
  
  all.counts <- rbind(all.counts, total.both, total.both.sex, total.both.age.cat1, 
                      total.both.age.cat2, total.both.hbres_2006)
  
  # CVD medicines
  pis.cvd <- merge(pis, tre.subgrps,  by.x = "bnf_code", by.y = "BNFCode")
  nrow(pis.cvd)
  
  total.cvd <- count.total(pis.cvd, "cvd", year, month)
  total.cvd.sex <- count.by.sex(pis.cvd, "cvd", year, month)  
  total.cvd.age.cat1 <- count.by.age.cat1(pis.cvd, "cvd", year, month)
  total.cvd.age.cat2 <- count.by.age.cat2(pis.cvd, "cvd", year, month)  
  total.cvd.hbres_2006 <- count.by.hbres_2006(pis.cvd, "cvd", year, month)
  
  all.counts <- rbind(all.counts, total.cvd, total.cvd.sex, total.cvd.age.cat1, 
                      total.cvd.age.cat2, total.cvd.hbres_2006)
  
  sub.grps <- unique(tre.subgrps$key_group)
  for (i in 1:length(sub.grps)) {
    pis.subgrp <- pis.cvd %>% filter(key_group == sub.grps[i])
    key_group <- sprintf("%s", sub.grps[i])
    total.sub.grp <- count.total(pis.subgrp, key_group, year, month)
    total.sub.grp.sex <- count.by.sex(pis.subgrp, key_group, year, month)  
    total.sub.grp.age.cat1 <- count.by.age.cat1(pis.subgrp, key_group, year, month)
    total.sub.grp.age.cat2 <- count.by.age.cat2(pis.subgrp, key_group, year, month)  
    total.sub.grp.hbres_2006 <- count.by.hbres_2006(pis.subgrp, key_group, year, month)  
    all.counts <- rbind(all.counts, total.sub.grp, total.sub.grp.sex, total.sub.grp.age.cat1, 
                        total.sub.grp.age.cat2, total.sub.grp.hbres_2006)
  }
  # Monthly incidence
  monthly.incidence <- pis.cvd %>% group_by(anon_id, key_group) %>% 
    mutate(month.rank = row_number(dispensed_date), year = year, month = month) %>%
    select(anon_id, dispensed_date, year, month, key_group, bnf_code, month.rank, year, month,
           sex, age_cat1, age_cat2, hbres_2006) %>%
    filter(month.rank == 1) %>%
    ungroup()
  
  print("About to return")
  return(list(all.counts, monthly.incidence))   
}

count.total <- function(pis, key_group, year, month) {
  total <- pis %>% count() %>%
    mutate(key_group = key_group, year = year, 
           month = month, strat_key = "", category = "") %>%
    rename(count = n) %>% 
    select(key_group, year, month, strat_key, category, count) 
  
  total
}

count.by.sex <- function(pis, key_group, year, month) {
  total <- pis %>% group_by(sex) %>% count() %>%
    mutate(strat_key = "sex", key_group = key_group, year = year, 
           month = month) %>% ungroup() %>%
    rename(count = n, category = sex) %>% 
    select(key_group, year, month, strat_key, category, count)
  
  total
}

count.by.age.cat1 <- function(pis, key_group, year, month) {
  total <- pis %>% group_by(age_cat1) %>% count() %>%
    mutate(strat_key = "age", key_group = key_group, year = year, 
           month = month) %>% ungroup() %>%
    rename(count = n, category = age_cat1) %>% 
    select(key_group, year, month, strat_key, , category, count)
  
  total
}

count.by.age.cat2 <- function(pis, key_group, year, month) {
  total <- pis %>% group_by(age_cat2) %>% count() %>%
    mutate(strat_key = "age_band_10", key_group = key_group, year = year, 
           month = month) %>% ungroup() %>%
    rename(count = n, category = age_cat2) %>% 
    select(key_group, year, month, strat_key, category, count)
  
  total
}

count.by.hbres_2006 <- function(pis, key_group, year, month) {
  total <- pis %>% group_by(hbres_2006) %>% count() %>%
    mutate(strat_key = "region", key_group = key_group, year = year, 
           month = month) %>% ungroup() %>%
    rename(count = n, category = hbres_2006) %>% 
    select(key_group, year, month, strat_key, category, count)
  
  total
}
