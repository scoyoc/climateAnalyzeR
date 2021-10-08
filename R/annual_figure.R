#' Line Figure with Area
#'
#' This function produces a standardized line graph with colored area under the line. This figure is used in RMarkdown scrips.
#'
#' @param x_var A character string of hte x-variable.
#' @param y_var A character string of the y-variable.
#' @param my_year A number for the your of interest. # TODO: make like consistent with project.
#' @param normal A number for the annual normal temperature or precipitation. Typically derived from \code{\link[climateAnalyzeR::normals]{normals}}.
#' @param reference_period Character string for the reference period used for normals.
#' @param area_color A character string for the color of the area. See \code{\link[grDevices::colors]{colors}} for a list of color names.
#' @param line_color A character string for the line color.
#' @param my_title A character string for the title.
#' @param my_ylab A character string from the y-axis.
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#' # TODO: use prcp data
annual_figure <- function(x_var, y_var, my_year, normal, reference_period, area_color,
                        line_color, my_title, my_ylab){
  #-- Crate dataframe
  # Plotting data
  dat = tibble::tibble(x_var, y_var)
  names(dat) = c("x", "y")
  # Label data
  lab_dat <- tibble::tibble(normal = normal,
                            label = paste0(reference_period, " Avg: ",
                                           round(normal, 1), "°F"))

  gg <- ggplot2::ggplot(dat, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_area(ggplot2::aes(x = x, y = y), stat = "identity",
                       fill = area_color, alpha = 0.5, na.rm = TRUE) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = normal),
                        linetype = "dashed", size = 0.5, color = "black") +
    ggplot2::geom_line(stat = "identity", color = line_color, size = 1) +
    ggplot2::geom_point(stat = "identity", color = line_color, size = 2) +
    ggplot2::geom_smooth(method = "lm", se = FALSE, color = "blue") +
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

