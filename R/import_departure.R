#' Import monthly departure data from ClimateAnalyzer.org into R.
#'
#' This function imports monthly departure data from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station The character string of the station name.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param month The month number (i.e., 1 for January through 12 for December)
#'     or 'all' for all months.
#' @param norm_per A character string for the 30-year normalization period.
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
#' # Import monthly departures and convert values to metric
#' import_departure('natural_bridges_nm', 2000, 2010, convert = TRUE)
#' # Import departures for the month of July
#' import_departure('natural_bridges_nm', 2000, 2010, month = 7)
import_departure <- function(station, start_year, end_year,
                                  month = 'all', norm_per = '1981-2010',
                                  convert = FALSE){
  # Pull montly data and omit NAs
  dat = pull_monthly(station, start_year, end_year, month = month,
                 table_type = "30dep", norm_per = norm_per) %>%
    stats::na.omit()
  # Rename variables
  colnames(dat) = c("Year", "Month", "PRCP_pctavg", "TMAX_depart", "TMIN_depart")
  # Munge data so all months are included with NA's if there are missing data
  dat = dat  %>%
    dplyr::mutate("Year" = as.numeric(Year),
                  "Month" = as.numeric(Month)) %>%
    tidyr::gather("Var", "Value", 3:ncol(.)) %>%
    tidyr::spread("Month", "Value", fill = NA) %>%
    tidyr::gather("Month", "Value", 3:ncol(.), convert = TRUE) %>%
    tidyr::spread("Var", "Value", fill = NA) %>%
    dplyr::arrange("Year", "Month")

  # Convert to metric
  if (convert == TRUE){
    dat = convert_temp(dat)
  }

  return(tibble::as_tibble(dat))
}

