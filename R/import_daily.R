#' Import daily weather data
#'
#' This function imports daily temperature and precipitation data from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station_id The character string of the station ID.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param convert Logical. If TRUE, data are precipitation and temperature
#'     values are converted to metric. These converted values are included as
#'     additional columns in the data frame denoted by "_mm" or "_C". Default is
#'     FALSE.
#'
#' @return A \code{\link[tibble:tibble]{tibble}}.
#' @seealso The \code{\link{import_data}} wrapper function.
#' @export
#'
#' @examples
#' # Import daily temperature and precipitation data
#' import_daily("hans_flat_rs", 2010, 2020)
#' # Import daily temperature and precipitation data and convert values to metric
#' import_daily("hans_flat_rs", 2010, 2020, convert = TRUE)
#'
import_daily <- function(station_id, start_year, end_year, convert = FALSE){

  my_url = paste0("http://climateanalyzer.science/python/u_thresh.py?station=",
                  station_id, "&year1=", start_year, "&year2=", end_year, "&title=",
                  station_id, "&lowerthresh=daily&upperthresh=70&station_type=GHCN&csv=true&param=temperature&time_mode=year&first_month=01&last_month=12&ann_sum=False&screen_blanks=False")
  dat = pull_csv(my_url, skip = 2)
  dat = rename_vars(dat)

  # Convert to metric
  if (convert == TRUE){
    dat = convert_prcp(dat)
    dat = convert_temp(dat)
  }

  names(dat) = janitor::make_clean_names(names(dat))
  return(tibble::as_tibble(dat))
}
