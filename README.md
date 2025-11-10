# climateAnalyzeR

This R package imports data from [ClimateAnalyzer.org](http://climateanalyzer.org/) into R. Currently annual, monthly, and daily weather data from [Global Historical Climatology Network](https://www.ncei.noaa.gov/products/land-based-station/global-historical-climatology-network-daily) Co-op stations are available.

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
library('climateAnalyzeR')

#-- Annual data
# Import annual temperature and precipitation data and remove columns of missing
#     values.
import_annual("canyonlands_theneck", 1980, 2020, convert = TRUE)

#-- Monthly data
# Import monthly precipitation and temperature data for the month of June
import_monthly('canyonlands_theneedle', 2000, 2010)

#-- Daily data
# Import daily temperature and precipitation data
import_daily("hans_flat_rs", 2010, 2020)

#-- Monthly departures
# Import departures for the month of July
import_departure('natural_bridges_nm', 2000, 2010)

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

-   `import_departure`: imports monthly departure data.

-   `import_extreme_temp`: imports the number of days per year that temperatures were below the 5th percentile and above the 95th percentile.

-   `import_monthly`: imports monthly temperature and precipitation data.

-   `monthly_figure`: produces a standardized line graph for monthly data.

-   `normals`: imports 30-year normals calculated by NOAA.

-   `renderSummary`: **Broken**. Render a PDF report.

-   `stations`: imports weather station information.

## List of Data

-   `month_df`: month numbers, 3-letter abbreviations, and season.
