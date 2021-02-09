#' Read data from ClimateAnalyzer.org into R
#'
#' This is a wrapper functions that imports data from ClimateAnalyzer.org
#'     into R.
#'
#' @param data_type a character string for the type of data to import.
#'     monthly_temp_prcp for monthly temperature and precipitation data.
#'     annual_temp_prcp for annual temperature and precipitation data.
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param ... Other arguments to pass to the child functions.
#'
#' @return A \code{\link[tibble]{tibble}}.
#'
#' @seealso \code{\link{import_daily}}, \code{\link{import_monthly}}
#'
#' @export
#'
#' @examples
#' # Import annual weather data.
#' import_data("annual_wx", "canyonlands_theneck", 1980, 2020, convert = TRUE)
#' import_data("annual_wx", "canyonlands_theneck", 1980, 2020, remove_missing = TRUE)
#'
#' # Import daily weather data
#' import_data("daily_wx", "hans_flat_rs", 2010, 2020, convert = TRUE)
#'
#' # Import monthly departures
#' import_data("monthly_depart", 'natural_bridges_nm', 2000, 2010, convert = TRUE)
#'
#' # Import montly weather data
#' import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010, convert = TRUE)
#' # Import weather data for June
#' import_data("monthly_wx", 'hovenweep_utah', 2000, 2010, month = 6)
#'
#' # Import water balance data with soil water capacity set to 100 and using the
#' # Hamon model.
#' import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
#'             soil_water = 100, pet_type = "hamon", forgiving = "very")
#' # Adjust the soil water capacity to 50 mm and use the Penman Montieth model.
#' import_data("water_balance", "arches", 2015, 2020, table_type = "daily",
#'             soil_water = 50, pet_type = "Penman_Montieth", forgiving = "very")
import_data <- function(data_type, station, start_year, end_year, ...){
  if(data_type == 'annual_wx'){
    dat = import_annual(station, start_year, end_year, ...)

  } else if(data_type == 'daily_wx'){
    dat = import_daily(station, start_year, end_year)

  } else if(data_type == "monthly_depart"){
    dat = import_monthly_depart(station, start_year, end_year, ...)

  } else if(data_type == 'monthly_wx'){
    dat = import_montly_wx(station, start_year, end_year, ...)

  } else if(data_type == "water_balance"){
    dat = import_water_balance(station, start_year, end_year, ...)

  } else(message("Data type not recognized."))

  return(dat)
}
