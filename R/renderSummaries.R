#' Render reports
#'
#' This funciton will render a PDF report from an RMarkdown (Rmd) script.
#'
#' @param station_id The station identification name for the weather station of
#'     interest.
#' @param station_name Optional. The name of the station to display in the report.
#'     Default is NULL. If left as NULL the station name will be pulled using the
#'     stations() function.
#' @param year The four-digit for the year of interest.
#' @param report Type of report to render. Currently the only option is a water
#'     year ("water_year") report.
#' @param my_dir String of direectory path to save repor to. If NULL, the report
#'     is saved to the your desktop.
#'
#' @return A PDF.
#' @export
#'
#' @examples
#' # Render a report for Arches National Park for the 2020 water year.
#' renderSummary("Arches National Park", 2020, "ARCH", report = "Water Year")
renderSummary = function(station_id, station_name = NULL, my_year,
                         report = "water_year", my_dir = NULL) {

  # Create 8-digit date stamp
  date_stamp = paste(stringr::str_split(lubridate::today(), "-")[[1]],
                     collapse = "")

  # Select station name
  if (is.null(station_name)){
    station_name = stations(my_stations = station_id)$name
  }

  # Select report
  if (report == "water_year"){
    my_rmd = "water_year_summary.Rmd"
    report_name = paste0(date_stamp, "_", station_name, " Water Year ", my_year, " Summary.pdf")
  } else (message("Report type not recognized. See help(renderSummary) for options."))


  # Select directory
  if (is.null(my_dir)){
    my_dir <- paste(Sys.getenv("USERPROFILE"), "Desktop", sep = "/")
  }

  # Render report
  rmarkdown::render(
    system.file("rmd", my_rmd, package = "climateAnalyzeR"),
    params = list(
      station_id = station_id,
      station_name = station_name,
      my_year = my_year
    ),
    output_file = paste(my_dir, report_name, sep = "/")
  )
}
