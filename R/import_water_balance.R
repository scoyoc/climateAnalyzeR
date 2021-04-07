#' Import water balance data from ClimateAnalyzer.org into R.
#'
#' This function imports daily or monthly water balance data from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
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
#' @return A \code{\link[tibble:tibble]{tibble}}.
#' @seealso The \code{\link{import_data}} wrapper function.
#' @export
#'
#' @examples
#' # Import monthly water balance data using the Hamon model with soil water
#' # capacity set to 100.
#' import_water_balance("arches", 2015, 2020, table_type = "monthly",
#'                      soil_water = 100, pet_type = "hamon",
#'                      forgiving = "very")
#' # Import daily water balance data using the Hamon model with soil water
#' # capacity set to 50
#' import_water_balance("arches", 2015, 2020, table_type = "daily",
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
  dat = pull_xml(my_url, skip = 1:2) %>%
    na.omit()
  dat = rename_vars(dat)
  names(dat) = janitor::make_clean_names(names(dat))

  if (ncol(dat) == 5){
    message("There are not enough data to produce a valid dataset.")
    return(tibble::as_tibble(dat))
    stop()
  }

  if (table_type == "monthly"){
    dat = dat %>%
      tidyr::separate("month", c("month", "year"), sep = "/") %>%
      dplyr::mutate("month" = as.numeric(month),
                    "year" = as.numeric(year)) %>%
      dplyr::select("year", "month", "deficit_mm", "prcp_mm", "rain_mm",
                    "daily_snow_mm", "snowpack_mm", "snow_melt_mm",
                    "water_input_to_soil_mm", "runoff_mm", "soil_water_mm",
                    "tmax_c", "tmin_c", "tmean_c",
                    "accum_growing_deg_days_c", "pet_mm", "aet_mm") %>%
      dplyr::mutate_at(c(3:ncol(.)), as.numeric)
    return(tibble::as_tibble(dat))
  }

  if (table_type == "daily"){
    dat = dat %>%
      dplyr::mutate("date" = lubridate::ymd(
                               lubridate::parse_date_time(date,
                                                          c("%m/%d/%Y")))) %>%
      dplyr::rename("snow_melt_mm" = "melt_mm") %>%
      dplyr::select("date", "deficit_mm", "prcp_mm", "rain_mm",
                    "daily_snow_mm", "snowpack_mm", "snow_melt_mm",
                    "water_input_to_soil_mm", "runoff_mm", "soil_water_mm",
                    "tmax_c", "tmin_c", "tmean_c",
                    "accum_growing_deg_days_c", "pet_mm", "aet_mm") %>%
      dplyr::mutate_at(c(2:ncol(.)), as.numeric)
    return(tibble::as_tibble(dat))
  }
}
