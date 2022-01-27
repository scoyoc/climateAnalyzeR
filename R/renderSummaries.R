#' Render reports
#'
#' This funciton will render a PDF report from an RMarkdown (Rmd) script.
#'
#' @param station_id The station identification name for the weather station of
#'     interest.
#' @param station_name Optional. A string to use for the station name. This is
#'     displayed in several location in the rendered report.Default is NULL. If
#'     NULL the station name will be pulled using
#'     \code{\link[climateAnalyzeR::stations]{stations}}.
#' @param my_year The four-digit for the year of interest. Default is NULL. The
#'     current year will be used if default is used.
#' @param report Type of report to render. Currently the only option is a water
#'     year ("water_year") report.
#' @param my_dir Optional. String of directory path to save report to. Default
#'     is NULL. If NULL, the report is saved to the your desktop.
#'
#' @return A PDF.
#' @export
#'
#' @examples
#' # Render a report for Arches National Park for the 2020 water year.
#' renderSummary("Arches National Park", 2020, "ARCH", report = "Water Year")
renderSummary = function(station_id, station_name = NULL, my_year = NULL,
                         my_report = "water_year", my_dir = NULL) {

  # Create 8-digit date stamp
  date_stamp = paste(stringr::str_split(lubridate::today(), "-")[[1]],
                     collapse = "")

  # Select station name
  if(is.null(station_name)){
    station_name = stations(my_stations = station_id)$name
  }

  # Select report
  if(my_report == "water_year" & is.null(my_year)){
    my_year = lubridate::year(lubridate::today())
    my_rmd = "current_water_year.Rmd"
    report_name = paste0(date_stamp, "_", station_id, "_WY", my_year, "_Summary.pdf")
    } else if(my_report == "water_year" & !is.null(my_year)){
      my_rmd = "past_water_year.Rmd"
      report_name = paste0(date_stamp, "_", station_id, "_WY", my_year, "_Summary.pdf")
      } else if(my_report == "annual" & is.null(my_year)){
        my_year = lubridate::year(lubridate::today())
        my_rmd = "current_annual.Rmd"
        report_name = paste0(date_stamp, "_", station_id, my_year, "_Summary.pdf")
        } else if(my_report == "annual" & !is.null(my_year)){
          my_rmd = "past_annual.Rmd"
          report_name = paste0(date_stamp, "_", station_id, my_year, "_Summary.pdf")
          } else(stop("Arguments not recognized: 'my_year' or 'my_report'. See help(renderSummary) for options."))

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
