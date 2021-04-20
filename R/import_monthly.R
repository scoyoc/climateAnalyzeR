#' Import monthly temperature and precipitation data from ClimateAnalyzer.org
#'     into R.
#'
#' This function imports monthly temperature and precipitation data from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station_id The character string of the station ID.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest.
#' @param month The month number (i.e., 1 for January through 12 for December)
#'     or 'all' for all months.
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
#' # Import monthly precipitation and temperature data and convert values to metric
#' import_monthly('canyonlands_theneedle', 2000, 2010, convert = TRUE)
#' # Import monthly precipitation and temperature data for the month of June
#' import_monthly('canyonlands_theneedle', 2000, 2010, month = 6)
import_monthly <- function(station_id, start_year, end_year, month = 'all',
                             convert = FALSE){
  # Pull monthly data and omit NAs
  dat = pull_monthly(station_id, start_year, end_year, month,
                       table_type = "straight", norm_per = 'null') %>%
    stats::na.omit()
  # Rename variables
  colnames(dat) = c("year", "month", "prcp", "tmax", "tmin")
  # Munge data so all months are included with NA's if there are missing data
  dat = dat  %>%
    dplyr::mutate("year" = as.numeric(year),
                  "month" = as.numeric(month)) %>%
    tidyr::gather("var", "value", 3:ncol(.)) %>%
    tidyr::spread("month", "value", fill = NA) %>%
    tidyr::gather("month", "value", 3:ncol(.), convert = TRUE) %>%
    tidyr::spread("var", "value", fill = NA) %>%
    dplyr::arrange("year", "month")

  # Convert to metric
  if (convert == TRUE){
    dat = convert_prcp(dat)
    dat = convert_temp(dat)
  }

  names(dat) = janitor::make_clean_names(names(dat))
  return(tibble::as_tibble(dat))
}
