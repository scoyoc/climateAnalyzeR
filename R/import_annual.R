#' Import annual weather data from ClimateAnalyzer.org into R
#'
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param screen_blanks A character string stating if years with 15 or more
#'     missing values will be screened out and the data replaced with NA.
#'     Options are 'true' or 'false'.
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
#' @param remove_missing Logical. If TRUE, columns that tally missing values are
#'     excluded from result. If FALSE, these columns are included in the result.
#'     Default is TRUE.
#' @param convert Logical. If TRUE, data are precipitation and temperature
#'     values are converted to metric. These converted values are included as
#'     additional columns in the data frame denoted by "_mm" or "_C". Default is
#'     FALSE.
<<<<<<< HEAD
=======
>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
#'
#' @return A \code{\link[tibble]{tibble}}.
#'
#' @seealso \code{\link{import_daily}}, \code{\link{import_monthly}}
#'
#' @export
#'
#' @examples
<<<<<<< HEAD
=======
<<<<<<< HEAD
#' import_annual("arches", 1980, 2020) %>%
#'   dplyr::select(-dplyr::contains("missing"))

import_annual = function(station, start_year, end_year, screen_blanks = 'true'){
=======
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
#' import_annual("canyonlands_theneck", 1980, 2020, convert = TRUE)
#' import_annual("canyonlands_theneck", 1980, 2020, remove_missing = FALSE)
import_annual = function(station, start_year, end_year, screen_blanks = 'true',
                         remove_missing = TRUE, convert = FALSE){
<<<<<<< HEAD
=======
>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
  my_url = paste0("http://climateanalyzer.science/python/u_thresh.py?station=",
                  station, "&year1=", end_year, "&year2=", start_year,
                  "&title=", station,
                  "&lowerthresh=daily&upperthresh=70&station_type=GHCN&csv=true&param=temperature&time_mode=year&first_month=01&last_month=12&ann_sum=True&screen_blanks=",
                  screen_blanks)
  dat = pull_csv(my_url, skip = 4)
<<<<<<< HEAD
=======
<<<<<<< HEAD
  return(tibble::as_tibble(dat))
}
=======
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
  colnames(dat) = c("Year", "PRCP_cy", "PRCP_cy_missing", "PRCP_wy",
                    "PRCP_wy_missing", "TMAX_cy", "TMAX_cy_missing", "TMAX_wy",
                    "TMAX_wy_missing", "TMIN_cy", "TMIN_cy_missing", "TMIN_wy",
                    "TMIN_wy_missing")
  # Remove missing tally columns
  if (remove_missing == TRUE){
    dat = dplyr::select(dat, -dplyr::contains("missing"))
  }

  # Convert to metric
  if (convert == TRUE){
    dat = convert_prcp(dat)
    dat = convert_temp(dat)
  }

  return(tibble::as_tibble(dat))
}
<<<<<<< HEAD
=======

>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
