#' Read daily weather data from ClimateAnalyzer.org into R
#'
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
#' @param convert Logical. If TRUE, data are precipitation and temperature
#'     values are converted to metric. These converted values are included as
#'     additional columns in the data frame denoted by "_mm" or "_C". Default is
#'     FALSE.
<<<<<<< HEAD
=======
>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
#'
#' @return A \code{\link[tibble:tibble]{tibble}}.
#'
#' @export
#'
#' @examples
<<<<<<< HEAD
#' import_daily("hans_flat_rs", 2010, 2020, convert = TRUE)
#'
import_daily <- function(station, start_year, end_year, convert = FALSE){
=======
<<<<<<< HEAD
#' import_daily("arches", 2010, 2020)
#'
import_daily <- function(station, start_year, end_year){
=======
#' import_daily("hans_flat_rs", 2010, 2020)
#'
import_daily <- function(station, start_year, end_year, convert = FALSE){
>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
  my_url = paste0("http://climateanalyzer.science/python/u_thresh.py?station=",
                  station, "&year1=", start_year, "&year2=", end_year, "&title=",
                  station, "&lowerthresh=daily&upperthresh=70&station_type=GHCN&csv=true&param=temperature&time_mode=year&first_month=01&last_month=12&ann_sum=False&screen_blanks=False")
  dat = pull_csv(my_url, skip = 2)
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
  dat = rename_vars(dat)

  # Convert to metric
  if (convert == TRUE){
    dat = convert_prcp(dat)
    dat = convert_temp(dat)
  }


<<<<<<< HEAD
=======
>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
  return(tibble::as_tibble(dat))
}
