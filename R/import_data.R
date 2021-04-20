#' Read data from ClimateAnalyzer.org into R.
#'
#' This function that imports data from temperature, precipitation, departure,
#'     and water balance data from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R. It
#'     is a wrapper function for other import functions in the
#'     climateAnalyzeR package.
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
#'     }
#' @param station_id The character string of the station ID.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param ... Other arguments to pass to the child functions.
#'
#' @return A \code{\link[tibble:tibble]{tibble}}.
#' @seealso
#' See \code{\link{import_annual}}, \code{\link{import_daily}},
#'     \code{\link{import_departure}}, \code{\link{import_monthly}}, and
#'     \code{\link{import_water_balance}} for details.
#' @export
#'
#' @examples
#' #-- Annual data
#' # Import annual temperature and precipitation data and convert values to metric
#' import_data("annual_wx", "canyonlands_theneck", 1980, 2020, convert = TRUE)
#' # Import annual temperature and precipitation data and remove columns of missing
#' # values tally.
#' import_data("annual_wx", "canyonlands_theneck", 1980, 2020, remove_missing = FALSE)
#'
#' #-- Daily data
#' # Import daily temperature and precipitation data
#' import_data("daily_wx", "hans_flat_rs", 2010, 2020)
#' # Import daily temperature and precipitation data and convert values to metric
#' import_data("daily_wx", "hans_flat_rs", 2010, 2020, convert = TRUE)
#'
#' #-- Monthly departures
#' # Import monthly departures and convert values to metric
#' import_data("departure", 'natural_bridges_nm', 2000, 2010, convert = TRUE)
#' # Import departures for the month of July
#' import_data("departure", 'natural_bridges_nm', 2000, 2010, month = 7)
#'
#' #-- Monthly data
#' # Import monthly precipitation and temperature data and convert values to metric
#' import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010, convert = TRUE)
#' # Import monthly precipitation and temperature data for the month of June
#' import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010, month = 6)
#'
#' #-- Water balance data
#' # Import monthly water balance data using the Hamon model with soil water
#' # capacity set to 100.
#' import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
#'             soil_water = 100, pet_type = "hamon", forgiving = "very")
#' # Import daily water balance data using the Hamon model with soil water
#' # capacity set to 50
#' import_data("water_balance", "arches", 2015, 2020, table_type = "daily",
#'             soil_water = 50, pet_type = "Penman_Montieth", forgiving = "very")
import_data <- function(data_type, station_id, start_year, end_year, ...){
  if(data_type == 'annual_wx'){
    dat = import_annual(station_id, start_year, end_year, ...)

  } else if(data_type == 'daily_wx'){
    dat = import_daily(station_id, start_year, end_year)

  } else if(data_type == "departure"){
    dat = import_departure(station_id, start_year, end_year, ...)

  } else if(data_type == 'monthly_wx'){
    dat = import_monthly(station_id, start_year, end_year, ...)

  } else if(data_type == "water_balance"){
    dat = import_water_balance(station_id, start_year, end_year, ...)

  } else(message("Data type not recognized."))

  return(dat)
}
