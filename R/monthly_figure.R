#' Grouped Line Figure
#'
#' This function produces a standardized line graph the is grouped by year. This
#' figure is used in RMarkdown scrips.
#'
#' @param x_var A vector of hte x-variable.
#' @param y_var A vector of the y-variable.
#' @param year_group A vector for the grouping variable.
#' @param y_intercept A number for the y-intercept of the reference line. Zero
#'     (0) or 100 are normally used.
#' @param my_year A 4-digit year. This variable is used to subset the data
#'     provided by x_var, y_var, and year_group for plotting, and as a label on
#'     the figure.
#' @param line_color A character string for the line color.See
#'     \code{\link[grDevices::colors]{colors}} for a list of color names.
#' @param my_title A character string for the title.
#' @param my_ylab A character string from the y-axis.
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#'
monthly_figure <- function(x_var, y_var, year_group, y_intercept, my_year,
                        line_color, my_title, my_ylab){ # Title of y-axis
  # Create dataframe
  dat = tibble::tibble(x_var, y_var, year_group)
  names(dat) = c("x", "y", "g")
  ref_lab = paste0(min(year_group, na.rm = TRUE), "-",
                   max(year_group, na.rm = TRUE))

  # Create figure
  gg = ggplot2::ggplot(dat, ggplot2::aes(x = x, y = y, group = g)) +
    ggplot2::geom_line(stat = "identity", color = "gray") +
    ggplot2::geom_hline(ggplot2::aes(yintercept = y_intercept),
                      linetype = "dashed", size = 0.5, color = "black") +
    ggplot2::geom_line(data = dplyr::filter(dat, g == my_year),
                       ggplot2::aes(x = x, y = y),
                       stat = "identity", color = line_color, size = 1) +
    ggplot2::geom_point(data = dplyr::filter(dat, g == my_year),
                        ggplot2::aes(x = x, y = y),
                        stat = "identity", color = line_color, size = 2) +
    shadowtext::geom_shadowtext(mapping = ggplot2::aes(x = -Inf, y = Inf,
                                              label = my_year),
                                color = line_color, bg.colour = "white",
                                hjust = -1.5, vjust = 1.5, fontface = "bold") +
    shadowtext::geom_shadowtext(mapping = ggplot2::aes(x = Inf, y = Inf,
                                                       label = ref_lab),
                                color = "gray40", bg.colour = "white",
                                hjust = 1.5, vjust = 1.5) +
    ggplot2::labs(title = my_title, y = my_ylab) +
    climateAnalyzeR_theme
  return(gg)
}
