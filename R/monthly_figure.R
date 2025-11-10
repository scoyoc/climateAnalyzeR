#' Monthly Figure
#'
#' This function produces a standardized line graph with colored area under the
#'     line and a trend line. This figure is used for monthly measurements (e.g.,
#'     precipitation or temperature) in RMarkdown scrips to produce reports.
#'
#' @param x_var A vector of the x-variable.
#' @param y_var A vector of the y-variable.
#' @param year_group A vector for the grouping variable.
#' @param y_intercept A number for the y-intercept of the reference line. Zero
#'     (0) or 100 are normally used.
#' @param my_year A 4-digit year. This variable is used to subset the data
#'     provided by x_var, y_var, and year_group for plotting, and as a label on
#'     the figure.
#' @param line_color A character string for the line color.See
#'     \code{\link[grDevices]{colors}} for a list of color names.
#' @param my_title A character string for the title.
#' @param my_ylab A character string from the y-axis.
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#' library(climateAnalyzeR)
#'
#' # Import monthly departures
#' dat <- import_departure('hovenweep_utah', 2000, 2021) |>
#'   # Create month data frame to make x axis lables
#'   dplyr::left_join(data.frame('month' = 1:12,
#'                               'month_abb' = factor(month.abb,
#'                                                    levels = month.abb)))
#'
#' # Plot data
#' monthly_figure(x_var = dat$month_abb, y_var = dat$tmax_depart,
#'                year_group = dat$year, y_intercept = 0, my_year = 2020,
#'                line_color = "red3",
#'                my_title = "TMAX Montly Departure, Hovenweep National Monument",
#'                my_ylab = "Departure (deg F)")
#'
monthly_figure <- function(x_var, y_var, year_group, y_intercept, my_year,
                        line_color, my_title, my_ylab){
  # Create dataframe
  dat = tibble::tibble(x_var, y_var, year_group)
  names(dat) = c("x", "y", "g")
  ref_lab = paste0(min(year_group, na.rm = TRUE), "-",
                   max(year_group, na.rm = TRUE))

  # Create figure
  gg = ggplot2::ggplot(dat, ggplot2::aes(x = x, y = y, group = g)) +
    ggplot2::geom_line(stat = "identity", color = "gray", na.rm = TRUE) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = y_intercept),
                      linetype = "dashed", size = 0.5, color = "black") +
    ggplot2::geom_line(data = dplyr::filter(dat, g == my_year),
                       ggplot2::aes(x = x, y = y), stat = "identity",
                       color = line_color, size = 1, na.rm = TRUE) +
    ggplot2::geom_point(data = dplyr::filter(dat, g == my_year),
                        ggplot2::aes(x = x, y = y), stat = "identity",
                        color = line_color, size = 2, na.rm = TRUE) +
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
