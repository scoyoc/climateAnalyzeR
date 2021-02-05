#' ---
#' title: "Developing an R Package to Produce Climate Reports"
#' author: "Matthew W. Van Scoyoc"
#' ---
#'
#' **Developed:** 02 February, 2021
#' **Data:** "http://www.climateanalyzer.org/"
#' **Notes:** This script documents the development of an R package to produce
#' climate reports to be hosed on ClimateAnalyzer.org

# Load packages
# install.packages("devtools", "roxygene", "testthat", "tidyverse", "fs", "knirt")
library("devtools")
available::available("climateanalyzer")

# Create package
usethis::create_package("~/Documents/R/climateanalyzer")
#-- Initialize a Git repository
usethis::use_git()
#-- Set license
usethis::use_mit_license("Southeast Utah Group, National Park Service, DOI")
#-- Create ReadMe.md
usethis::use_readme_md()

#-- Delete NAMESPACE file and man directory
file.remove("NAMESPACE")
unlink("man", recursive = T)
#-- Create new NAMESPACE file and man directory
devtools::document()
devtools::check()
devtools::load_all()

# Add packages to DESCRIPTION
sessionInfo()
# Imports:
usethis::use_package("readr", "Imports")
usethis::use_package("XML", "Imports")

# Suggests
usethis::use_package("tidyverse", "Suggests")

rm(list = ls())
devtools::document()
devtools::check()
devtools::load_all()
