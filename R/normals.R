#' Import NOAA calculated normals
#'
#' This function imports 30-year normals calculated by NOAA from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#'
#' @param ref_period The string for 30-year reference period. The user can choose
#'     "1971-2000" or "1981-2010". Default is "1981-2010".
#' @param my_stations Optional. A string to filter results by a station name.
#'     Default is NULL. If NULL, a data frame of 30-year normals for all stations
#'     on climateAnalyzer.org will be returned.
#' @param tidy Logical. Returns tidy data. Default is TRUE.
#'     \describe{
#'         \item{TRUE}{Returns a tidy data frame of temperature (tmax and tmin)
#'             and precipitation data. This option drops seasonal earliest/last
#'             dates for temperatures and number of days above/below
#'             temperatures.}
#'         \item{FALSE}{Returns the raw dat from ClimateAnalyzer.org.}
#'     }
#'
#' @return A \code{\link[tibble:tibble]{tibble}}.
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' # Import 1981-2010 normals. Default.
#' normals(my_stations = "capitol_reef_np")
#'
#' # Import 1971-2000 normals for multiple stations.
#' normals(ref_period = "1971-2000", my_stations = c("blue_mesa_lake", "cimarron",
#'                                                   "black_canyon_of_the_gunnison"))
#'
normals <- function(ref_period = "1981-2010", my_stations = NULL, tidy = TRUE){
  if (ref_period == "1971-2000"){
    my_url = "http://climateanalyzer.science/monthly/1971_2000_averages.csv"
  } else if (ref_period == "1981-2010"){
    my_url = "http://climateanalyzer.science/monthly/1981_2010_averages.csv"
  } else (message('Reference period not recogized. Use "1971-2000" or "1981-2010".'))

  dat = suppressMessages(
    suppressWarnings(
      readr::read_csv(my_url, col_names = TRUE, na = "N/A",
                      skip_empty_rows = TRUE) |>
        dplyr::select(!dplyr::starts_with("X")) |>
        dplyr::rename("station_id" = 'Station Name',
                      "id" = 'Station ID')
    )
  )
  names(dat) = janitor::make_clean_names(names(dat))

  # Force data type conversion
  dat = dat[, 1:2] |>
    dplyr::bind_cols(
      suppressWarnings(dplyr::mutate_all(dat[, c(3:43)], as.numeric))
    ) |>
    dplyr::bind_cols(dat[, 44:47]) |>
    dplyr::bind_cols(
      suppressWarnings(dplyr::mutate_all(dat[, c(48:length(dat))], as.numeric))
    )

  if (isTRUE(tidy)) {
    # precipitation
    prcp = dplyr::select(dat, dplyr::contains("precip"))
    names(prcp) = c(month.abb, "Annual")
    prcp = dplyr::bind_cols(dplyr::select(dat, "station_id", "id"), prcp) |>
      dplyr::mutate(element = "PRCP")
    # tmax
    tmax = dplyr::select(dat, dplyr::contains("tmax"))
    names(tmax) = c(month.abb, "Annual")
    tmax = dplyr::bind_cols(dplyr::select(dat, "station_id", "id"), tmax) |>
      dplyr::mutate(element = "TMAX")
    # tmin
    tmin = dplyr::select(dat, dplyr::contains("tmin"), "annual")
    names(tmin) = c(month.abb, "Annual")
    tmin = dplyr::bind_cols(dplyr::select(dat, "station_id", "id"), tmin) |>
      dplyr::mutate(element = "TMIN")
    # comgine temp and precp data sets and make tidy
    dat = dplyr::bind_rows(prcp, tmax, tmin) |>
      tidyr::gather(month, value, Jan:Annual) |>
      dplyr::mutate(month = factor(month, levels = c(month.abb, "Annual"))) |>
      dplyr::arrange(element, station_id, month)
  }

  # Filter by station name
  if (!is.null(my_stations)){
    dat = dplyr::filter(dat, station_id %in% my_stations)
  }

  # Return dataframe
  return(dat)
}
