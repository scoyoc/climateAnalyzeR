# climateAnalyzeR

<!-- badges: start -->
<!-- badges: end -->

This package imports data from ClimateAnalyzer.org into R. It is currently 
under development and only imports annual, daily, and monthly weather data from 
Co-op stations and water balance data for those Co-op stations. The plan is to 
incorporate more data sets that are available on ClimateAnalyzer.org.

## Installation

Perhaps someday you will be able to install the released version of 
climateAnalyzeR from [CRAN](https://CRAN.R-project.org). Right now you can 
install it form GitHub.

``` r
devtools::install_github("scoyoc/climateAnalyzeR")
```

## Example

Below are examples of how to import data from ClimateAnalyzer.orgin to R.

``` r
library(climateAnalyzeR)
# Examples of Existing Functions ----
#-- Annual data
# Import annual temperature and precipitation data and convert values to metric
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, convert = TRUE)
# Import annual temperature and precipitation data and remove columns of missing
# values tally.
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, remove_missing = FALSE)

#-- Daily data
# Import daily temperature and precipitation data
import_data("daily_wx", "hans_flat_rs", 2010, 2020)
# Import daily temperature and precipitation data and convert values to metric
import_data("daily_wx", "hans_flat_rs", 2010, 2020, convert = TRUE)

#-- Monthly departures
# Import monthly departures and convert values to metric
import_data("departure", 'natural_bridges_nm', 2000, 2010, convert = TRUE)
# Import departures for the month of July
import_data("departure", 'natural_bridges_nm', 2000, 2010, month = 7)

#-- Monthly data
# Import monthly precipitation and temperature data and convert values to metric
import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010, convert = TRUE)
# Import monthly precipitation and temperature data for the month of June
import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010, month = 6)

#-- Water balance data
# Import monthly water balance data using the Hamon model with soil water
# capacity set to 100.
import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
            soil_water = 100, pet_type = "hamon", forgiving = "very")
# Import daily water balance data using the Hamon model with soil water
# capacity set to 50
import_data("water_balance", "arches", 2015, 2020, table_type = "daily",
            soil_water = 50, pet_type = "Penman_Montieth", forgiving = "very")
```

