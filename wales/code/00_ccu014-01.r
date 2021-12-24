# clear the environment ========================================================
rm(list=ls())
gc()
setwd("P:/torabif/workspace/CCU014-01")
# load options, packages and functions =========================================

# packages =====================================================================
message("Loading packages:")

pkgs <- c(
  "assertr",
  "beepr",
  "broom",
  "dplyr",
  "dtplyr",
  "forcats",
  "ggplot2",
  "ggthemes",
  "knitr",
  "kableExtra",
  "mice",
  "janitor",
  "lubridate",
  "qs",
  "rmarkdown",
  "sailr",
  "scales",
  "stringr",
  "readr",
  "survival",
  "tableone",
  "tidyr",
  # Fatemeh uses the following:
  "RODBC",
  "Cairo",
  "lattice",
  "getopt",
  "gtsummary"
)

for (pkg in pkgs) {
  suppressWarnings(
    suppressPackageStartupMessages(
      library(pkg, character.only = TRUE)
    )
  )
  message("\t", pkg, sep = "")
}

# report =======================================================================

# for gitlab
render(
	input = "README.Rmd",
	output_format = md_document(),
	quiet = TRUE
)

# for local viewing
render(
	input = "README.rmd",
	output_file = "README.html",
	quiet = TRUE
)
