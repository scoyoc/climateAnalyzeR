#' Append water year and water month to a data frame
#'
#' This function appends five (5) columns to the input data set based on the
#'     month and year columns: `water_month`, `month_name`, `season`,
#'     `water_yr`, and `water_mth.`
#'
#' @param dat A data frame containing numeric 'month' and 'year' columns.
#'
#' @returns A [tibble::tibble()]
#'
#' @details The following columns are appended to the input data frame:
#'
#' * `water_month`: Numeric. Water month Oct-Sep (1-12).
#' * `month_name`: Factor. Abbreviated month name with levels corresponding to the calendar year (Jan-Dec).
#' * `season`: Character. season based on water year (DJF, MAM, JJA, SON)
#' * `water_yr`: Numeric. Year corresponding to water year
#' * `water_mth`: Factor. Abbreviated month name with levels corresponding to the water year (Oct-Sep).
#'
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' # Import monthly departures and append water year and water month
#' import_departure("canyonlands_theneck", 1965, 2025) |>
#'   append_water_yr_mth()
#'
append_water_yr_mth <- function(dat){
  dat = tibble::tibble(dat) |>
    dplyr::left_join(month_df, by = "month") |>
    dplyr::mutate(
      "water_yr" = ifelse(month >= 10, year +1, year),
      "water_mth" = factor(month_name,
                           levels = c(month.abb[10:12], month.abb[1:9]))
    )
  return(dat)
}
