#' Import station information
#'
#' This function imports weather station information from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param my_name A string of the station name. This is used to reduce the data
#'     frame using \code{\link[dplyr::filter]{filter}}. Default is NULL.
#' @param my_stations A string of the station id. This is used to reduce the data
#'     frame using \code{\link[dplyr::filter]{filter}}. Default is NULL.
#' @param my_id A string of the station Id. This is used to reduce the data
#'     frame using \code{\link[dplyr::filter]{filter}}. Default is NULL.
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
#' stations(my_id = c("426053", "424100"))
stations <- function(my_name = NULL, my_stations = NULL, my_id = NULL){
  dat = suppressMessages(
    suppressWarnings(
      readr::read_csv("http://climateanalyzer.science/all_stations.csv",
                      col_names = TRUE, na = "nan",
                      skip_empty_rows = TRUE) |>
        dplyr::select(-dplyr::contains("dir")) |>
        dplyr::select(!dplyr::starts_with("X")) |>
        dplyr::left_join(dplyr::filter(climateAnalyzeR::normals()[, 1:2],
                                       id != "COOP" & id != "manual" &
                                         id != "null" & id != "SNOTEL"),
                         by = c("ID" = "id"))
    )
  )
  names(dat) = janitor::make_clean_names(names(dat))

  # Reduce data frame
  # Filter by station name
  if(!is.null(my_name)){
    dat = dplyr::filter(dat, name %in% my_name)
    } else if(!is.null(my_stations)){
      dat = dplyr::filter(dat, station_id %in% my_stations)
      } else if(!is.null(my_id)){
        dat = dplyr::filter(dat, id %in% my_id)
        } else (message("Station ID name not recognized in station_id argument. Find the correct station ID by using climateAnalyzeR::stations() or by going to ClimateAnalyzer.org."))

  return(dplyr::select(dat, "name", "station_id", "id", "type", "lat", "lon",
                "elev_m", "years_avail", "years_segments", "data_url"))
}
