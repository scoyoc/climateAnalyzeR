#' Import monthly temperature and precipitation data
#'
#' This function imports monthly temperature and precipitation data from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station_id The character string of the \emph{station_id} field from
#'     \code{\link{stations}}.
#' @param start_year The four digit number of the first year of interest.
#' @param end_year The four digit number of the last year of interest. Default
#'     is NULL. If NULL, current year will be used.
#' @param month A number for the month, 1 for January through 12 for December
#'     or 'all' for all months. Default is 'all'.
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
#' # Import monthly precipitation and temperature data
#' import_monthly(station_id = 'canyonlands_theneedle', start_year = 2000,
#'                end_year = 2010)
#'
#' # Import monthly precipitation and temperature data for the month of June and
#' # convert values to metric
#' import_monthly(station_id = 'canyonlands_theneedle', start_year = 2000,
#'                end_year = 2010, month = 6, convert = TRUE)
#'
import_monthly <- function(station_id, start_year, end_year = NULL,
                           month = 'all', convert = FALSE){

  if(is.null(end_year)){end_year = lubridate::year(lubridate::today())}
  # Pull monthly data and omit NAs
  dat = pull_monthly(station_id, start_year, end_year, month,
                       table_type = "straight", norm_per = 'null') |>
    stats::na.omit()
  # Rename variables
  colnames(dat) = c("year", "month", "prcp", "tmax", "tmin")
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
    dat = convert_prcp(dat)
    dat = convert_temp(dat)
  }

  names(dat) = janitor::make_clean_names(names(dat))
  return(tibble::as_tibble(dat))
}
