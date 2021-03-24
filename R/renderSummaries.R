#' Render reports
#'
#' This funciton will render a PDF report from an RMarkdown (Rmd) script.
#'
#' @param park_name The full name of the park unit of interest.
#' @param water_yr The four-digit water year you want to summarize.
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
renderSummary = function(park_name, water_yr, my_park, report="Water Year",
                         my_dir = NULL) {
  # Report
  if (report == "Water Year"){
    my_rmd = "wySummary.Rmd"
    } else (message("Report type not recognized. Refer to the help page for options."))

  # Directory
  if (is.null(my_dir)){
    my_dir <- paste(Sys.getenv("USERPROFILE"), "Desktop", sep = "\\")
  }

  rmarkdown::render(
    system.file("rmd", my_rmd, package = "climateAnalyseR"),
    params = list(
      park_name = park_name,
      water_yr = water_yr,
      my_park = my_park
    ),
    output_file = paste(my_dir,
                        paste0(paste(str_split(today(), "-")[[1]], collapse = ""),
                               "_", my_park, "_WaterYearSummary_", water_yr, ".pdf"),
                        sep = "/")
  )
}
