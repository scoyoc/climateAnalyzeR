#' Import monthly departure data
#'
#' This function imports monthly departure data from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station_id The character string of the \emph{station_id} field from
#'     \code{\link{stations}}.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest. Default
#'     is NULL. If NULL, current year will be used.
#' @param month A number for the month, 1 for January through 12 for December
#'     or 'all' for all months. Default is 'all'.
#' @param norm_per A character string for the 30-year normalization period.
#'     Either '1971-2000', '1981-2010', or '1991-2020'. Default is '1981-2010'.
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
#' # Import monthly departures
#' import_departure(station_id = 'natural_bridges_nm', start_year = 2000)
#'
#' # Import departures for the month of July  and convert values to metric
#' import_departure(station_id = 'natural_bridges_nm', start_year = 2000,
#'                  end_year = 2020, month = 7, convert = TRUE)
#'
import_departure <- function(station_id, start_year, end_year = NULL,
                             month = 'all', norm_per = '1981-2010',
                             convert = FALSE){

  if(is.null(end_year)){end_year = lubridate::year(lubridate::today())}
  # Pull montly data and omit NAs
  dat = pull_monthly(station_id, start_year, end_year, month = month,
                     table_type = "30dep", norm_per = norm_per) |>
    stats::na.omit()
  # Rename variables
  colnames(dat) = c("year", "month", "prcp_pctavg", "tmax_depart", "tmin_depart")
  # Munge data so all months are included with NA's if there are missing data
  dat = dat  |>
    dplyr::mutate("year" = as.numeric(year),
                  "month" = as.numeric(month)) |>
    tidyr::gather("var", "value", c(-1, -2)) |>
    tidyr::spread("month", "value", fill = NA) |>
    tidyr::gather("month", "value", c(-1, -2), convert = TRUE) |>
    tidyr::spread("var", "value", fill = NA) |>
    dplyr::arrange("year", "month")

  # Convert to metric
  if (convert == TRUE){
    dat = convert_temp(dat)
  }

  names(dat) = janitor::make_clean_names(names(dat))
  return(tibble::as_tibble(dat))
}

