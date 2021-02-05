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
#' @examples
#' # Import annual temperature and precipitation data and remove columns of
#' # missing data counts.
#' import_data("annual_wx", "arches", 1980, 2020) %>%
#'   dplyr::select(-dplyr::contains("missing"))
#'
#' # Import monthly temperature and precipitation data.
#' import_data("monthly_wx", "canyonlands_theneck", 1965, 2020)
#' # Import June temperature and precipiation data
#' import_data("monthly_wx", "canyonlands_theneck", 1965, 2020, month = 6)
#'
#'
#' # Import monthly departures using the 1981-2010 30-year normalization period.
#' import_data("monthly_depart", "hans_flat_rs", 1980, 2020, norm_per = "1981-2010")
#' # Import monthly departures and set the 30-year normalization period to 1971-2010.
#' import_data("monthly_depart", "hans_flat_rs", 1980, 2020, norm_per = "1971-2000")
#'
#' # Import water balance data
#' # Using the recommended soil water capacity of 100 mm using the Hamon model.
#' import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
#'   soil_water = 100, pet_type = "hamon",  forgiving = "very")
#' # Adjust the soil water capacity to 50 mm and use the Penman_Montieth model.
#' import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
#'            soil_water = 50, pet_type = "Penman_Montieth", forgiving = "very")
#'
#' @export
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
