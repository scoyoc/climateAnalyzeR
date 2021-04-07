#' Import NOAA calculated normals from ClimateAnalyzer.org
#'
#' This function imports 30-year normals from
#'     \href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
#'

#' @param ref_period string for 30-year reference period. The user can choose
#'     "1971-2000" or "1981-2010" Default is "1981-2010".
#' @param my_station Optional. A string to filter results by a station name.
#'     Default is NULL. If NULL, a data frame of 30-year normals for all stations
#'     on climateAnalyzer.org will be returned.
#'
#' @return A \code{\link[tibble:tibble]{tibble}}.
#' @export
#'
#' @examples
#' # 1981-2010 normals for Arches National Park
#' normals(my_station = "arches")
#' # 1971-2000 normals for Arches National Park
#' normals(ref_period = "1971-2000", my_station = "arches")
normals <- function(ref_period = "1981-2010", my_station = NULL){
  if (ref_period == "1971-2000"){
    my_url = "http://climateanalyzer.science/monthly/1971_2000_averages.csv"
  } else if (ref_period == "1981-2010"){
    my_url = "http://climateanalyzer.science/monthly/1981_2010_averages.csv"
  } else (message('Reference period not recogized. Use "1971-2000" or "1981-2010".'))

  dat = suppressMessages(
    suppressWarnings(
      readr::read_csv(my_url, col_names = TRUE, na = "N/A", skip_empty_rows = TRUE) %>%
        dplyr::select(!dplyr::starts_with("X"))
    )
  )
  names(dat) = janitor::make_clean_names(names(dat))

  # Filter by station name
  if (!is.null(my_station)){
    dat = dplyr::filter(dat, station_name %in% my_station)
  }

  # Return dataframe
  return(dat)
}
