#' Render reports
#'
#' This funciton will render a PDF report from an RMarkdown (Rmd) script.
#'
#' @param station_id The station identification name for the weather station of interest.
#' @param station_name Optional. The name of the station to display in the report.
#' @param year The four-digit for the year of interest.
#' @param report Type of report to render. Currently the only option is a water year ("water_year") report.
#' @param my_dir String of direectory path to save repor to. If NULL, the report is saved to the your desktop.
#'
#' @return
#' @export
#'
#' @examples
#' # Render a report for Arches National Park for the 2020 water year.
#' renderSummary("Arches National Park", 2020, "ARCH", report = "Water Year")
renderSummary = function(station_id, station_name = NULL, year,
                         report = "water_year", my_dir = NULL) {

  # Select report
  if (report == "water_year"){
    my_rmd = "wySummary.Rmd"
  } else (message("Report type not recognized. See help(renderSummary) for options."))

  # Select station name
  if (is.null(station_name)){
    station_name = stations(my_station = station_id)$name
  }

  # Select directory
  if (is.null(my_dir)){
    my_dir <- paste(Sys.getenv("USERPROFILE"), "Desktop", sep = "/")
  }

  # Create 8-digit date stamp
  date_stamp = paste(stringr::str_split(lubridate::today(), "-")[[1]],
                     collapse = "")

  # Render report
  rmarkdown::render(
    system.file("rmd", my_rmd, package = "climateAnalyzeR"),
    params = list(
      station_id = station_id,
      station_name = station_name,
      year = year
    ),
    output_file = paste(my_dir,
                        paste0(date_stamp, "_", station_id, " ", year, " ",
                               report, " Summary.pdf"),
                        sep = "/")
  )
}
