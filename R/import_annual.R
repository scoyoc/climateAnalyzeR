#' Import annual temperature and precipitation data
#'
#' This function imports annual temperature and precipitation data from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station_id The character string of the \emph{station_id} field from
#'     \code{\link{stations}}.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest. Default
#'     is NULL. If NULL, current year will be used.
#' @param screen_blanks A character string stating if years with 15 or more
#'     missing values will be screened out and the data replaced with NA.
#'     Options are 'true' or 'false', in lower case not upper case. This object
#'     is included directly into the URL to retrieve the data from
#'     ClimateAnalyzer.org.
#' @param remove_missing Logical. If TRUE, columns that tally missing values are
#'     excluded from result. If FALSE, these columns are included in the result.
#'     Default is TRUE.
#' @param convert Logical. If TRUE, data are precipitation and temperature
#'     values are converted to metric. These converted values are included as
#'     additional columns in the data frame denoted by "_mm" or "_C". Default is
#'     FALSE.
#'
#' @return A \code{\link[tibble]{tibble}}.
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' # Import annual temperature and precipitation data
#' import_annual(station_id = "zion_np", start_year = 1980)
#'
#' # Import annual temperature and precipitation data and convert values to metric
#' import_annual(station_id = "zion_np", start_year = 1980, end_year = 2020,
#'               convert = TRUE)
#'
import_annual = function(station_id, start_year, end_year = NULL,
                         screen_blanks = 'true', remove_missing = TRUE,
                         convert = FALSE){

  if(is.null(end_year)){end_year = lubridate::year(lubridate::today())}
  my_url = paste0("http://climateanalyzer.science/python/u_thresh.py?station=",
                  station_id, "&year1=", end_year, "&year2=", start_year,
                  "&title=", station_id,
                  "&lowerthresh=daily&upperthresh=70&station_type=GHCN&csv=true&param=temperature&time_mode=year&first_month=01&last_month=12&ann_sum=True&screen_blanks=",
                  screen_blanks)
  dat = pull_csv(my_url, skip = 4)
  colnames(dat) = c("year", "prcp_cy", "prcp_cy_missing", "prcp_wy",
                    "prcp_wy_missing", "tmax_cy", "tmax_cy_missing", "tmax_wy",
                    "tmax_wy_missing", "tmin_cy", "tmin_cy_missing", "tmin_wy",
                    "tmin_wy_missing")

  # Remove missing tally columns
  if (remove_missing == TRUE){
    dat = dplyr::select(dat, -dplyr::contains("missing"))
  }

  # Convert to metric
  if (convert == TRUE){
    dat = convert_prcp(dat)
    dat = convert_temp(dat)
  }

  names(dat) = janitor::make_clean_names(names(dat))
  return(tibble::as_tibble(dat))
}
