#' Annual Figure
#'
#' This function produces a standardized line graph with colored area under the
#'     line and a trend line. This figure is used for annual measurements (e.g.,
#'     precipitation or temperature) in RMarkdown scrips to produce reports.
#'
#' @param x_var A character string of the x-variable. This is intended to be a
#'     vector of years.
#' @param y_var A character string of the y-variable. This is intended to be a
#'     vector of measurements (e.g., PRCP or TEMP).
#' @param my_year A number for the your of interest.
#' @param normal A number for the annual normal temperature or precipitation.
#'     Typically from \code{\link{normals}}.
#' @param reference_period Character string for the reference period used for
#'     normals (e.g., "1981-2010").
#' @param area_color A character string for the color of the area. See
#'     \code{\link[grDevices]{colors}} for a list of color names.
#' @param line_color A character string for the line color.
#' @param my_title A character string for the title.
#' @param my_ylab A character string from the y-axis.
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' # Set my station
#' my_station <- "colorado_nm"
#'
#' # Import annual data from ClimateAnalyzer.org
#' dat <-  import_annual(station_id =  my_station, start_year = 1980,
#'                       end_year = 2020)
#'
#' # Import NOAA calculated normals
#' prcp_30yr <- normals(station_id = my_station) |>
#'   dplyr::filter(element == "PRCP" & month == "Annual")
#'
#' # Plot data
#' annual_figure(x_var = dat$year, y_var = dat$prcp_wy, my_year = 2019,
#'               normal = prcp_30yr$value, reference_period = "1981-2010",
#'               area_color = "green3", line_color = "darkgreen",
#'               my_title = "Annual Precipitation, Colorado National Monument",
#'               my_ylab = "PRCP (inches)")
#'
annual_figure <- function(x_var, y_var, my_year, normal, reference_period,
                          area_color, line_color, my_title, my_ylab){

  # Crate dataframe
  dat = tibble::tibble(x_var, y_var)
  names(dat) = c("x", "y")
  # Label data
  lab_dat <- tibble::tibble(normal = normal,
                            label = paste0(reference_period, " Avg: ",
                                           round(normal, 1), " deg F"))

  gg <- ggplot2::ggplot(dat, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_area(ggplot2::aes(x = x, y = y), stat = "identity",
                       fill = area_color, alpha = 0.5, na.rm = TRUE) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = normal),
                        linetype = "dashed", linewidth = 0.5, color = "black") +
    ggplot2::geom_line(stat = "identity", color = line_color, linewidth = 1,
                       na.rm = TRUE) +
    ggplot2::geom_point(stat = "identity", color = line_color, size = 2,
                        na.rm = TRUE) +
    ggplot2::geom_smooth(method = "lm", se = FALSE, color = "blue",
                         na.rm = TRUE) +
    ggplot2::geom_point(data = dplyr::filter(dat, x == my_year),
                        stat = "identity", shape = 21, color = "black",
                        fill = line_color, size = 4) +
    shadowtext::geom_shadowtext(lab_dat,
                                mapping = ggplot2::aes(x = -Inf, y = normal,
                                                       label = label),
                                color = "black", bg.colour = "white", size = 3,
                                hjust = -0.1, vjust = -0.5) +
    ggplot2::coord_cartesian(xlim = c(min(dat$x), max(dat$x)),
                             ylim = c(floor(min(y_var, na.rm = T)),
                                      ceiling(max(y_var, na.rm = T)))) +
    ggplot2::labs(title = my_title, y = my_ylab) +
    climateAnalyzeR_theme

  return(gg)
}

