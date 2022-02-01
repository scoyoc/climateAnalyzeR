#' Render reports
#'
#' This function will render a PDF report from an RMarkdown (Rmd) script.
#'
#' @param my_report Type of report to render. The options are a calendar
#'     year ("calendar_year") and a water year ("water_year") report.
#' @param station_id The character string of the \emph{station_id} field from
#'     \code{\link{stations}}..
#' @param station_name Optional. A string to be use for the station name in the
#'     report. Default is NULL. If NULL the station name will be pulled from
#'     \code{\link{stations}}. This is displayed in several location in the
#'     report and the default name can be changed.
#' @param my_year Optional. The four-digit year of interest. Default is NULL. The
#'     current year will be used if left as NULL.
#' @param my_dir Optional. String of directory path to save report to. Default
#'     is NULL. If NULL, the report is saved to the your desktop.
#'
#' @return A PDF.
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' # Render water year report for current water year
#' renderSummary(my_report = "water_year", station_id = "hans_flat_rs")
#'
#' # Render calendar year report for 2018 with custom station name
#' renderSummary(my_report = "calendar_year", station_id = "canyonlands_theneck",
#'               station_name = "Island in the Sky, Canyonlands National Park",
#'               my_year = 2018)
#'
renderSummary = function(my_report, station_id, station_name = NULL,
                         my_year = NULL, my_dir = NULL) {
  my_station = station_id
  #-- Validataion routine
  # Check station name
  if(nrow(climateAnalyzeR::stations(station_id = my_station) |>
         dplyr::distinct()) == 0){
    stop("Station ID name not recognized in station_id argument. Find the correct station ID by using climateAnalyzeR::stations() or by going to ClimateAnalyzer.org.")
  }

  # Create 8-digit date stamp
  date_stamp = paste(stringr::str_split(lubridate::today(), "-")[[1]],
                     collapse = "")

  # Select station name
  if(is.null(station_name)){
    station_name = stations(station_id = my_station)$name[1]
  }

  # Select report
  if(my_report == "water_year" & is.null(my_year)){
    # Check date
    if(lubridate::today() > lubridate::date(paste(lubridate::year(lubridate::today()), 10, 01, sep = "-")) &
       lubridate::today() < lubridate::date(paste(lubridate::year(lubridate::today()), 11, 15, sep = "-"))){
      stop(glue::glue("Cannot render summary. Data are not currently available for water year {my_year}."))
    }
    my_year = lubridate::year(lubridate::today())
    my_rmd = "current_water_year.Rmd"
    report_name = paste0(date_stamp, "_", station_id, "_WY", my_year, "_Summary.pdf")
    } else if(my_report == "water_year" & !is.null(my_year)){
      my_rmd = "past_water_year.Rmd"
      report_name = paste0(date_stamp, "_", station_id, "_WY", my_year, "_Summary.pdf")
      } else if(my_report == "calendar_year" & is.null(my_year)){
        # Check date
        if(lubridate::today() < lubridate::date(paste(lubridate::year(lubridate::today()),
                                                      02, 15, sep = "-"))){
          stop(glue::glue("Cannot render summary. Data are not currently available for {my_year}."))
        }
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
  suppressWarnings(
    rmarkdown::render(system.file("rmd", my_rmd, package = "climateAnalyzeR"),
                      params = list(station_id = my_station,
                                    station_name = station_name,
                                    my_year = my_year),
                      output_file = paste(my_dir, report_name, sep = "/"))
    )
}
