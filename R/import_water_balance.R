#' Import water balance data from ClimateAnalyzer.org into R
#'
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param table_type A character string for 'daily' or 'monthly' data.
#' @param pet_type A character string for the model type. Options are 'Hamon' or
#'     'Penman_Montieth'.
#' @param soil_water a number (integer) for the soil depth in milimeters. If you are not
#'     sure use 100.
#' @param forgiving A string for the tolorance of the model. Options are 'no',
#'     'mild' and 'very'.
#'
#' @return A \code{\link[tibble]{tibble}}.
#'
#' @export
#'
#' @examples
#' import_water_balance("arches", 2015, 2020, table_type = "monthly",
#'                      soil_water = 100, pet_type = "hamon",
#'                      forgiving = "very")
#' # Adjust the soil water capacity to 50 mm and use the Penman_Montieth model.
#' import_water_balance("arches", 2015, 2020, table_type = "monthly",
#'                      soil_water = 50, pet_type = "Penman_Montieth",
#'                      forgiving = "very")

import_water_balance <- function(station, start_year, end_year, table_type,
                                 pet_type, soil_water, forgiving){
  my_url = paste0("http://www.climateanalyzer.science/python/wb.py?station=",
                  station, "&title=", station, "&pet_type=", pet_type,
                  "&max_soil_water=", soil_water, "&graph_table=table&",
                  "table_type=", table_type, "&forgiving=", forgiving,
                  "&year1=", start_year, "&year2=", end_year,
                  "&station_type=GHCN&csv=true")
  dat = pull_xml(my_url, skip = 1:2)
  return(tibble::as_tibble(dat))
}
