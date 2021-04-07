#' Import station informaiton from ClimateAnalyzer.org
#'
#' @param station_name A string of the station name. This is used as an argument
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
#' stations(station_name = "Arches NP")
#' stations(station_name = c("Canyonlands The Neck", "Canyonlands The Needle", "Hans Flat RS"))
stations <- function(station_name = NULL){
  dat = suppressMessages(
    suppressWarnings(
      readr::read_csv("http://climateanalyzer.science/all_stations.csv",
                      col_names = TRUE, na = "nan",
                      skip_empty_rows = TRUE) %>%
        dplyr::select(-dplyr::contains(c("X", "dir")))
    )
  )
  names(dat) = janitor::make_clean_names(names(dat))

  # Filter by station name
  if (!is.null(station_name)){
    dat = dplyr::filter(dat, name %in% station_name)
  }

  # Return dataframe
  return(dat)
}
