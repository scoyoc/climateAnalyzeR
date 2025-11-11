#' Import station information
#'
#' This function imports weather station information from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'
#' @param type A string to filter the returned data frame by station type.
#'     Default is NULL. If NULL, the entire data frame is returned. Station
#'     types include:
#'     - "buoy" = NOAA National Bouy Center data
#'     - "Canadian" = Canadian Historical Climate Data station
#'     - "CHIS" = California weather stations
#'     - "COOP" = NOAA Global Historical Climatology Network Co-op station
#'     - "findu" = Arizona weather stations
#'     - "HADS" = NOAA Hydrometeorological Automated Data System (HADS)
#'     - "Manual" = Manually entered data
#'     - "RAWS" = NIFC Remote Automatic Weather Station (RAWS)
#'     - "snotel" = NRCS SNOTEL station
#'     - "stream" = USGS Stream gauge
#'     - "USBR" = US Bureau of Reclamation
#'     - "USDA" = US Department of Agriculture
#'     - "ventura" = Ventura County, California weather station
#'     - "PIMA" = Pima County, Arizona weather station
#'     - "MET" = Other NOAA weather stations, e.g., airports and municipalities
#'     - "co_stream" = Great Sand Dunes National Park stream gauges
#' @param station_name A string of the station \emph{name}. This is used to
#'     filter the returned data frame using \code{\link[dplyr]{filter}}. Default
#'     is NULL. If NULL, the entire data frame is returned.
#' @param station_id A string of the \emph{station_id}. This is used to filter
#'     the data frame using \code{\link[dplyr]{filter}}. Default is NULL. If
#'     NULL, the entire data frame is returned.
#' @param id A string of the station \emph{id}. This is used to filter the
#'     data frame using \code{\link[dplyr]{filter}}. Default is NULL. If NULL,
#'     the entire data frame is returned.
#'
#' @return A \code{\link[tibble]{tibble}}.
#'
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' # Import all information for all stations.
#' stations()
#'
#' # Import all GHCN Co-op stations.
#' stations(type = "COOP")
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
stations <- function(type = NULL, station_name = NULL, station_id = NULL,
                     id = NULL){

  my_type = type; my_name = station_name; my_station_id = station_id
  my_id = id

  dat = readr::read_csv("http://climateanalyzer.science/all_stations.csv",
                        col_names = TRUE, na = "nan", skip_empty_rows = TRUE,
                        show_col_types = FALSE) |>
    janitor::clean_names() |>
    dplyr::rename("station_name" = name) |>
    dplyr::mutate(elev_m = as.numeric(elev_m)) |>
    dplyr::select(-dplyr::contains("dir")) |>
    dplyr::select(!dplyr::starts_with("x")) |>
    dplyr::distinct() |>
    # dplyr::left_join(climateAnalyzeR::normals()[, 1:2] |> dplyr::distinct(),
    #                  by = "id") |>
    # dplyr::mutate(
    #   station_id = ifelse(is.na(station_id),
    #                       gsub(" ", "_", tolower(station_name)),
    #                       station_id)
    #   ) |>
    dplyr::select("station_name", "id", "type", "lat", "lon", "elev_m",
                  "years_avail", "years_segments", "data_url") |>
    suppressWarnings() |>
    suppressMessages()

  # Reduce data frame
  if(!is.null(my_name)){
    dat = dat[dat$station_name %in% my_name, ]
    } else if(!is.null(my_station_id)){
      dat = dat[dat$station_id %in% my_station_id, ]
      } else if(!is.null(my_id)){
        dat = dat[dat$id %in% my_id, ]
      } else if(!is.null(my_type)){
          dat = dat[dat$type %in% my_type, ]
        }

  return(dat)
}
