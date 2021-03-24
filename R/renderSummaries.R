#' Render reports
#'
#' This funciton will render a PDF report from an RMarkdown (Rmd) script.
#'
#' @param park_name The full name of the park unit of interest.
#' @param water_yr The four-digit water year you want to summarize.
#' @param my_park The four-letter park code for the park of interest.
#' @param report  Type of report to render. Currently the only option is "Water Year".
#'
#' @return
#' @export
#'
#' @examples
#' # Render a report for Arches National Park for the 2020 water year.
#' renderSummary("Arches National Park", 2020, "ARCH", report = "Water Year")
renderSummary = function(park_name, water_yr, my_park, report="Water Year") {
  if (report == "Water Year"){
    my_rmd = "wySummary.Rmd"
    } else (message("Report type not recognized. Refer to the help page for options."))
  rmarkdown::render(
    my_rmd, params = list(
      park_name = park_name,
      water_yr = water_yr,
      my_park = my_park
    ),
    output_file = paste(paste(getwd(), "Results", sep = "/"),
                        paste0(paste(str_split(today(), "-")[[1]], collapse = ""),
                               "_", my_park, "_WaterYearSummary_", water_yr, ".pdf"),
                        sep = "/")
  )
}
