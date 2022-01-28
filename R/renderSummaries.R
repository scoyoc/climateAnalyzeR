#' Render reports
#'
#' This function will render a PDF report from an RMarkdown (Rmd) script.
#'
#' @param my_report Type of report to render. The options are a calendar
#'     year ("calendar_year") and a water year ("water_year") report.
#' @param station_id The "station_id" field for the weather station of interest
#'     from \code{\link[climateAnalyzeR::stations]{stations}}.
#' @param station_name Optional. A string to be use for the station name in the
#'     report. Default is NULL. If NULL the station name will be pulled from
#'     \code{\link[climateAnalyzeR::stations]{stations}}. This is displayed in
#'     several location in the report and the default name can be changed.
#' @param my_year Optional. The four-digit year of interest. Default is NULL. The
#'     current year will be used if left as NULL.
#' @param my_dir Optional. String of directory path to save report to. Default
#'     is NULL. If NULL, the report is saved to the your desktop.
#'
#' @return A PDF.
#' @export
#'
#' @examples
#' # Render a report for Arches National Park for the 2020 water year.
#' renderSummary()
renderSummary = function(my_report, station_id, station_name = NULL,
                         my_year = NULL, my_dir = NULL) {

  if(nrow(climateAnalyzeR::stations(my_stations = station_id) |> dplyr::distinct()) == 0){
    stop("Station ID name not recognized in station_id argument. Find the correct station ID by using climateAnalyzeR::stations() or by going to ClimateAnalyzer.org.")
  }

  # Create 8-digit date stamp
  date_stamp = paste(stringr::str_split(lubridate::today(), "-")[[1]],
                     collapse = "")

  # Select station name
  if(is.null(station_name)){
    station_name = stations(my_stations = station_id)$name[1]
  }

  # Select report
  if(my_report == "water_year" & is.null(my_year)){
    my_year = lubridate::year(lubridate::today())
    my_rmd = "current_water_year.Rmd"
    report_name = paste0(date_stamp, "_", station_id, "_WY", my_year, "_Summary.pdf")
    } else if(my_report == "water_year" & !is.null(my_year)){
      my_rmd = "past_water_year.Rmd"
      report_name = paste0(date_stamp, "_", station_id, "_WY", my_year, "_Summary.pdf")
      } else if(my_report == "calendar_year" & is.null(my_year)){
        my_year = lubridate::year(lubridate::today())
        my_rmd = "current_annual.Rmd"
        report_name = paste0(date_stamp, "_", station_id, "_", my_year, "_Summary.pdf")
        } else if(my_report == "calendar_year" & !is.null(my_year)){
          my_rmd = "past_annual.Rmd"
          report_name = paste0(date_stamp, "_", station_id, "_", my_year, "_Summary.pdf")
          } else(stop("Argument not recognized: 'my_report' or 'my_year'. See help(renderSummary) for options."))

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
