# climateAnalyzeR

<!-- badges: start -->
<!-- badges: end -->

The primary function of this package is to produce brief climate reports using temperature and precipitation data from National Park Service Co-op stations using RMarkdown (*.Rmd). 
Currently a water year (Oct-Sep) report is available, and an annual (Jan-Dec) report is in development. 

This package also imports data from [ClimateAnalyzer.org](http://climateanalyzer.org/) into R. 
Currently  annual, monthly, and dialy weather data and water balance models for those stations are available. 
The plan is to incorporate more data sets available on ClimateAnalyzer.org.

## Installation

Perhaps someday you will be able to install the released version of 
climateAnalyzeR from [CRAN](https://CRAN.R-project.org). Right now you can 
install it form GitHub.

``` r
devtools::install_github("scoyoc/climateAnalyzeR")
```

## Examples

Here is the function that renders pdf reports using RMarkdown.
```r
library(climateAnalyzeR)

renderSummary(station_id = "arches",
              station_name = "Arches National Park",
              my_year = 2020)
```

Below are examples of function that import data from ClimateAnalyzer.org.

``` r
#-- Annual data
# Import annual temperature and precipitation data and remove columns of missing
# values.
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, 
            remove_missing = FALSE)

# Import annual temperature and precipitation data and convert values to metric
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, convert = TRUE)

#-- Daily data
# Import daily temperature and precipitation data
import_data("daily_wx", "hans_flat_rs", 2010, 2020)

#-- Monthly data
# Import monthly precipitation and temperature data for the month of June
import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010, month = 6)

#-- Monthly departures
# Import departures for the month of July
import_data("departure", 'natural_bridges_nm', 2000, 2010, month = 7)

#-- Water balance data
# Import monthly water balance data using the Hamon model with soil water
# capacity set to 100.
import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
            soil_water = 100, pet_type = "hamon", forgiving = "very")
```

