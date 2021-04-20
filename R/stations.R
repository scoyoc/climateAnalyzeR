#' Import station informaiton from ClimateAnalyzer.org
#'
#' This function imports weather station information from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param my_stations A string of the station name. This is used as an argument
#'     for dplyr::filter to reduce the data frame to the desired stations.
#'     Default is NULL. If NULL, a data frame of all stations is returned.
#'
#' @return A \code{\link[tibble:tibble]{tibble}}.
#' @export
#'
#' @examples
#' # Import all information for all stations.
#' stations()
#'
#' # Filter station by name
#' stations(my_stations = "arches")
#' stations(my_stations = c("Canyonlands The Neck", "Canyonlands The Needle", "Hans Flat RS"))
stations <- function(my_stations = NULL){
  dat = suppressMessages(
    suppressWarnings(
      readr::read_csv("http://climateanalyzer.science/all_stations.csv",
                      col_names = TRUE, na = "nan",
                      skip_empty_rows = TRUE) %>%
        dplyr::select(-dplyr::contains("dir")) %>%
        dplyr::select(!dplyr::starts_with("X")) %>%
        dplyr::left_join(dplyr::filter(climateAnalyzeR::normals()[, 1:2],
                                       id != "COOP" & id != "manual" &
                                         id != "null" & id != "SNOTEL"),
                         by = c("ID" = "id"))
    )
  )
  names(dat) = janitor::make_clean_names(names(dat))


  # Filter by station name
  if (!is.null(my_stations)){
    dat = dplyr::filter(dat, station_id %in% my_stations)
  }

  # Return dataframe
  return(dplyr::select(dat, "name", "station_id", "id", "type", "lat", "lon",
                "elev_m", "years_avail", "years_segments", "data_url"))
}
