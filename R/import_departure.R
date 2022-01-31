#' Import monthly departure data
#'
#' This function imports monthly departure data from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station_id The character string of the station ID.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param month The month number (i.e., 1 for January through 12 for December)
#'     or 'all' for all months. Dafault is 'all'.
#' @param norm_per A character string for the 30-year normalization period.
#'     Either '1971-2000' or '1981-2010'. Default is '1981-2010'.
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
#' # Import departures from 2000-2010
#' import_departure('natural_bridges_nm', 2000, 2010)
#'
#' #' # Import departures for the month of July
#' import_departure('natural_bridges_nm', 2000, 2010, month = 7)
#'
#' #' # Import monthly departures and convert values to metric
#' import_departure('natural_bridges_nm', 2000, 2010, convert = TRUE)
#'
import_departure <- function(station_id, start_year, end_year,
                             month = 'all', norm_per = '1981-2010',
                             convert = FALSE){
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
    tidyr::gather("var", "value", 3:ncol(.)) |>
    tidyr::spread("month", "value", fill = NA) |>
    tidyr::gather("month", "value", 3:ncol(.), convert = TRUE) |>
    tidyr::spread("var", "value", fill = NA) |>
    dplyr::arrange("year", "month")

  # Convert to metric
  if (convert == TRUE){
    dat = convert_temp(dat)
  }

  names(dat) = janitor::make_clean_names(names(dat))
  return(tibble::as_tibble(dat))
}

