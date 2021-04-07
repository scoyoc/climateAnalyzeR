#' Render reports
#'
#' This funciton will render a PDF report from an RMarkdown (Rmd) script.
#'
#' @param park_name The full name of the park unit of interest.
#' @param  The four-digit water year you want to summarize.
#' @param my_park The four-letter park code for the park of interest.
#' @param report  Type of report to render. Currently the only option is "Water Year".
#' @param my_dir Direectory to save repor to. If NULL, the report is saved to the your desktop.
#'
#' @return
#' @export
#'
#' @examples
#' # Render a report for Arches National Park for the 2020 water year.
#' renderSummary("Arches National Park", 2020, "ARCH", report = "Water Year")
renderSummary = function(park_name, year, my_park, report="water year",
                         my_dir = NULL) {

  # Select report
  if (report == "water year"){
    my_rmd = "wySummary.Rmd"
    } else (message("Report type not recognized. Refer to the help page for options."))

  # Select directory
  if (is.null(my_dir)){
    my_dir <- paste(Sys.getenv("USERPROFILE"), "Desktop", sep = "/")
  }

  # Create 8-digit date stamp
  date_stamp = paste(stringr::str_split(lubridate::today(), "-")[[1]], collapse = "")

  # Render report
  rmarkdown::render(
    system.file("rmd", my_rmd, package = "climateAnalyzeR"),
    params = list(
      park_name = park_name,
      year = year,
      my_park = my_park
    ),
    output_file = paste(my_dir,
                        paste0(date_stamp, "_", my_park, " ", year, " ", report,
                               " Summary.pdf"),
                        sep = "/")
  )
}
