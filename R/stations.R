#' Import station information
#'
#' This function imports weather station information from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param station_name A string of the station \emph{name}. This is used to reduce
#'     the data frame using \code{\link[dplyr]{filter}}. Default is NULL.
#' @param station_id A string of the \emph{station_id}. This is used to reduce
#'     the data frame using \code{\link[dplyr]{filter}}. Default is NULL.
#' @param id A string of the station \emph{id}. This is used to reduce the
#'     data frame using \code{\link[dplyr]{filter}}. Default is NULL.
#'
#' @return A \code{\link[tibble]{tibble}}.
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' # Import all information for all stations.
#' stations()
#'
#' # Import station inforation using the name of the station
#' stations(station_name = "Black Canyon of the Gunnison")
#'
#' # Import information for multiple stations using station_id
#' stations(station_id = c("blue_mesa_lake", "black_canyon_of_the_gunnison"))
#'
#' # Import information for multiple stations using id numbers
#' stations(id = c(50754, 50797))
#'
stations <- function(station_name = NULL, station_id = NULL, id = NULL){
  if(!is.null(station_id)){my_station = station_id} else my_station = NULL
  if(!is.null(id)){my_id = id} else my_id = NULL

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
  if(!is.null(station_name)){
    dat = dplyr::filter(dat, name %in% station_name)
    } else if(!is.null(my_station)){
      dat = dplyr::filter(dat, station_id %in% my_station)
      } else if(!is.null(my_id)){
        dat = dplyr::filter(dat, id %in% my_id)
        }

  dat <- dplyr::select(dat, "name", "station_id", "id", "type", "lat", "lon",
                "elev_m", "years_avail", "years_segments", "data_url") |>
    unique()
  return(dat)
}
