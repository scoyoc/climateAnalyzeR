# climateAnalyzeR

<!-- badges: start -->
<!-- badges: end -->

The primary function of this R package is to produce brief climate reports using temperature and precipitation data from National Park Service Co-op stations using RMarkdown. 
Currently awater year (Oct-Sep) and calendar year (Jan-Dec) reports have been developed. 
The plan is to include water balance summaries to the RMarkdown scripts in the future.

This package also imports data from [ClimateAnalyzer.org](http://climateanalyzer.org/) into R. 
Currently  annual, monthly, and daily weather data and water balance models for Co-op stations are available.

Version: 0.9.0

Depends: R (>= 4.0)

Imports: cowplot, dplyr, ggplot2, glue, ggmap, grid, gridExtra, knitr, janitor, lubridate, readr, rmarkdown, shadowtext, stats, stringr, tidyr, tibble, XML

Suggests: tidyverse

Author: Matthew Van Scoyoc

Maintainer: Matthew Van Scoyoc

Issues: [https://github.com/scoyoc/climateAnalyzeR/issues](https://github.com/scoyoc/climateAnalyzeR/issues)

License: MIT + file [LICENSE](https://github.com/scoyoc/climateAnalyzeR/blob/master/LICENSE.md)

URL: [https://github.com/scoyoc/climateAnalyzeR](https://github.com/scoyoc/climateAnalyzeR)

Documentation: Just the man pages for now. A vignette is being developed.

## Installation

Perhaps someday you will be able to install this package from [CRAN](https://CRAN.R-project.org), but for now you can 
install it form GitHub.

``` r
devtools::install_github("scoyoc/climateAnalyzeR")
```

## Examples

Below are examples that produce PDF reports.
```r
library(climateAnalyzeR)

# Current water year summary for Arches National Park using the default station 
# name on ClimateAnalyzer.org
renderSummary(my_report = "water_year", station_id = "arches")

# Calendar year report for Island in the Sky for 2018 and changing the name used 
# in the report.
renderSummary(my_report = "calendar_year", station_id = "canyonlands_theneck", 
              station_name = "Island in the Sky, Canyonlands National Park", 
              my_year = 2018)
```

Below are examples of functions that import data from [ClimateAnalyzer.org](http://climateanalyzer.org/).

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

