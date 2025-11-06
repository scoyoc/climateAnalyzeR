# climateAnalyzeR

This R package imports data from [ClimateAnalyzer.org](http://climateanalyzer.org/) into R. Currently annual, monthly, daily weather data, temperatures above and below a specified temperature, and water balance models for Co-op stations are available.

This R package can also produce brief climate reports using temperature and precipitation data from Co-op stations using RMarkdown. Currently water year (Oct-Sep) and calendar year (Jan-Dec) reports are available.

**Version:** 0.9.2

**Depends:** R (\>= 4.0)

**Imports:** cowplot, dplyr, ggplot2, glue, ggmap, grid, gridExtra, knitr, janitor, lubridate, readr, rmarkdown, shadowtext, stats, stringr, tidyr, tibble, utils, XML

**Suggests:** tidyverse

**Author:** [Matthew Van Scoyoc](https://github.com/scoyoc)

**Contributors:** [Kara Raymond](https://github.com/kararaymond)

**Maintainer:** [Matthew Van Scoyoc](https://github.com/scoyoc)

**Issues:** As of November 06, 2025, most functions worked. Please continue to report issues to <https://github.com/scoyoc/climateAnalyzeR/issues>. Below are the known issues.

-   Rendering PDF reports is broken. This is a known [issue](https://github.com/scoyoc/climateAnalyzeR/issues/5).

-   Importing water balance data is broken. This is a known [issue](https://github.com/scoyoc/climateAnalyzeR/issues/4).

-   Importing daily data using the `import_data()` function is broken. This is a known [issue](https://github.com/scoyoc/climateAnalyzeR/issues/6).

**License:** MIT + file [LICENSE](https://github.com/scoyoc/climateAnalyzeR/blob/master/LICENSE.md)

**URL:** <https://github.com/scoyoc/climateAnalyzeR>

**Documentation:** Just the man pages for now.

## Installation

``` r
devtools::install_github("scoyoc/climateAnalyzeR")
```

## Examples

Below are examples of functions that import data from [ClimateAnalyzer.org](http://climateanalyzer.org/).

``` r
#-- Annual data
# Import annual temperature and precipitation data and remove columns of missing
#     values.
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
#     capacity set to 100.
import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
            soil_water = 100, pet_type = "hamon", forgiving = "very")

#-- Number of days per year above/below user set temperature
# Import the number of days per year that are below a user set minimum 
#     temperature and above a user set maximum temperatures.
import_below_above_temp(station_id = "tumacacori", start_year = 1991,
                        end_year = 2020, tmin_temp = 20, tmax_temp = 100,
                        station_type = "GHCN", year = "year")

#-- Count of days under the 5th percentile and above the 95th percentile
# Import the number of days per year that temperatures were below the 5th
#     percentile and above the 95th percentile.
import_extreme_temp(station_id = "tumacacori", start_year = 1991, 
                    end_year = 2020, station_type = "GHCN", year = "year")
```

Below are examples that produce PDF reports.

``` r
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

## List of Functions

-   `annual_figure`: produces a standardized line graph for annual data.

-   `import_annual`: imports annual temperature and precipitation data from ClimateAnalyzer.org into R.

-   `import_below_above_temp`: imports the number of days per year that are below a user \#' defined minimum temperature and above a user defined maximum temperature.

-   `import_daily`: imports daily temperature and precipitation data.

-   `import_data`: a wrapper for data import functions in this package. Importing daily data using this function is broken.

-   `import_departure`: imports monthly departure data.

-   `import_extreme_temp`: imports the number of days per year that temperatures were below the 5th percentile and above the 95th percentile.

-   `import_monthly`: imports monthly temperature and precipitation data.

-   `import_water_balance`: **Broken**. Imports daily or monthly water balance data.

-   `monthly_figure`: produces a standardized line graph for monthly data.

-   `normals`: imports 30-year normals calculated by NOAA.

-   `renderSummary`: **Broken**. Render a PDF report.

-   `stations`: imports weather station information.

## List of Data

-   `month_df`: month numbers, 3-letter abbreviations, and season.
