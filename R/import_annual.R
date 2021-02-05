#' Import annual weather data from ClimateAnalyzer.org into R
#'
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param screen_blanks A character string stating if years with 15 or more
#'     missing values will be screened out and the data replaced with NA.
#'     Options are 'true' or 'false'.
#'
#' @return A \code{\link[tibble]{tibble}}.
#'
#' @seealso \code{\link{import_daily}}, \code{\link{import_monthly}}
#'
#' @export
#'
#' @examples
#' import_annual("arches", 1980, 2020) %>%
#'   dplyr::select(-dplyr::contains("missing"))

import_annual = function(station, start_year, end_year, screen_blanks = 'true'){
  my_url = paste0("http://climateanalyzer.science/python/u_thresh.py?station=",
                  station, "&year1=", end_year, "&year2=", start_year,
                  "&title=", station,
                  "&lowerthresh=daily&upperthresh=70&station_type=GHCN&csv=true&param=temperature&time_mode=year&first_month=01&last_month=12&ann_sum=True&screen_blanks=",
                  screen_blanks)
  dat = pull_csv(my_url, skip = 4)
  return(tibble::as_tibble(dat))
}
