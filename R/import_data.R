#' Read data from ClimateAnalyzer.org into R.
#'
#' This is a wrapper for data import functions in the climateAnalyzeR package.
#'
#' @param data_type A character string for the type of data to import.
#'     \itemize{
#'         \item \emph{annual_wx}: Annual temperature and precipitation data.
#'             See \code{\link{import_annual}} for details.
#'         \item \emph{daily_wx}: Daily temperature and precipitation data.
#'             See \code{\link{import_daily}} for details.
#'         \item \emph{departure}: Monthly departure data.
#'             See \code{\link{import_departure}} for details.
#'         \item \emph{monthly_wx}: Monthly temperature and precipitation data.
#'             See \code{\link{import_monthly}} for details.
#'         \item \emph{water_balance}: Water balance data.
#'             See \code{\link{import_water_balance}} for details.
#'         \item \emph{extreme_temp}: Days below and above percentile temp data.
#'             See \code{\link{import_extreme_temp}} for details.
#'         \item \emph{below_above_tempe}: Days below and above user set temp data.
#'             See \code{\link{import_below_above_temp}} for details.
#'     }
#' @param station_id The character string of the \emph{station_id} field from
#'     \code{\link{stations}}.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest. Default
#'     is NULL. If NULL, current year will be used.
#' @param ... Other arguments to pass to the import functions.
#'
#' @return A \code{\link[tibble]{tibble}}.
#' @seealso
#' See \code{\link{import_annual}}, \code{\link{import_daily}},
#'     \code{\link{import_departure}}, \code{\link{import_monthly}},
#'     \code{\link{import_extreme_temp}}, \code{\link{import_below_above_temp}},
#'     and \code{\link{import_water_balance}} for details.
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' #-- Wrapper Function
#' # Import annual temperature and precipitation data
#' import_data("annual_wx", station_id = "zion_np", start_year = 1980)
#'
#' # Import daily temperature and precipitation data
#' import_data("daily_wx", station_id = "arches", start_year = 2010,
#'             station_type = "GHCN")
#'
#' # Import monthly departures
#' import_data("departure", station_id = "natural_bridges_nm", start_year = 2000)
#'
#' # Import monthly precipitation and temperature data
#' import_data("monthly_wx", station_id = "canyonlands_theneedle",
#'             start_year = 2000)
#'
#' # Import monthly water balance data using the Hamon model with soil water
#' # capacity set to 100.
#' import_data("water_balance", station_id = "bryce_canyon_np", start_year = 2015,
#'             end_year = 2020, table_type = "monthly", soil_water = 100,
#'             pet_type = "hamon", forgiving = "very")
#'
#'  # Import number of days annually with minimum temperatures below the 5th
#'  # percentile temperature and number of days above the 95th percentile
#'  import_extreme_temp(station_id = "tumacacori", start_year = 1991, end_year =
#'                      2020, station_type = "GHCN", year = "year")
#'
#'  # Imports number of days annually with minimum and maximum daily
#'  # temperatures below and above user set temperatures
#'  import_below_above_temp(station_id = "tumacacori", start_year = 1991,
#'                          end_year =2020, tmin_temp = 20, tmax_temp = 100,
#'                          station_type = "GHCN", year = "year")
#'
#'
import_data <- function(data_type, station_id, start_year, end_year = NULL, ...){
  if(data_type == 'annual_wx'){
    dat = import_annual(station_id, start_year, end_year, ...)

  } else if(data_type == 'daily_wx'){
    dat = import_daily(station_id, start_year, end_year, ...)

  } else if(data_type == "departure"){
    dat = import_departure(station_id, start_year, end_year, ...)

  } else if(data_type == 'monthly_wx'){
    dat = import_monthly(station_id, start_year, end_year, ...)

  } else if(data_type == "water_balance"){
    dat = import_water_balance(station_id, start_year, end_year, ...)

  } else if(data_type == "extreme_temp"){
    dat = import_extreme_temp(station_id, start_year, end_year, ...)

  } else if(data_type == "below_above_temp"){
    dat = import_below_above_temp(station_id, start_year, end_year, ...)

  } else(message("Data type not recognized."))

  return(dat)
}
