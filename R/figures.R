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
annual_figure <- function(x_var, y_var, normal, reference_period,
                          area_color, line_color, my_title, my_ylab){

  # Crate dataframe
  dat = tibble::tibble(x_var, y_var)
  names(dat) = c("x", "y")

  # Determine data type labeling
  data_type <- if (grepl("F", my_ylab) |
                   grepl("fahrenheit", tolower(my_ylab))){
    "°F"
  } else if (grepl("C", my_ylab) |
             grepl("celsius", tolower(my_ylab)) |
             grepl("centigrade", tolower(my_ylab))){
    "°C"
  } else if (grepl("inches", tolower(my_ylab)) |
             grepl("inch", tolower(my_ylab))){
    " inches"
  } else if (grepl("mm", tolower(my_ylab)) |
             grepl("millimeters", tolower(my_ylab))){
    " mm"
  } else {""}

  # Label data
  lab_dat <- tibble::tibble(normal = normal,
                            label = paste0(reference_period, " Avg: ",
                                           round(normal, 1), data_type))

  # Create figure
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
    # if (!is.null(my_year)){
    # ggplot2::geom_point(data = dplyr::filter(dat, x == my_year),
    #                     stat = "identity", shape = 21, color = "black",
    #                     fill = line_color, size = 4)
    #   } +
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


#' Monthly Figure
#'
#' This function produces a standardized line graph with colored area under the
#'     line and a trend line. This figure is used for monthly measurements (e.g.,
#'     precipitation or temperature) in RMarkdown scrips to produce reports.
#'
#' @param x_var A vector of the x-variable.
#' @param y_var A vector of the y-variable.
#' @param year_group A vector for the grouping variable.
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
#'   dplyr::left_join(
#'     data.frame('month' = 1:12,
#'                'month_abb' = factor(month.abb, levels = month.abb))
#'     )
#'
#' # Plot data
#' monthly_figure(x_var = dat$month_abb, y_var = dat$tmax_depart,
#'                year_group = dat$year, my_year = 2020,
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
    # ggplot2::geom_hline(ggplot2::aes(yintercept = y_intercept),
    #                   linetype = "dashed", size = 0.5, color = "black") +
    ggplot2::geom_line(data = dplyr::filter(dat, g == my_year),
                       ggplot2::aes(x = x, y = y), stat = "identity",
                       color = line_color, size = 1, na.rm = TRUE) +
    ggplot2::geom_point(data = dplyr::filter(dat, g == my_year),
                        ggplot2::aes(x = x, y = y), stat = "identity",
                        color = line_color, size = 2, na.rm = TRUE) +
    shadowtext::geom_shadowtext(
      mapping = ggplot2::aes(x = -Inf, y = Inf, label = my_year),
      color = line_color, bg.colour = "white", hjust = -1.5, vjust = 1.5,
      fontface = "bold"
      ) +
    shadowtext::geom_shadowtext(
      mapping = ggplot2::aes(x = Inf, y = Inf, label = ref_lab),
      color = "gray40", bg.colour = "white", hjust = 1.5, vjust = 1.5
      ) +
    ggplot2::labs(title = my_title, y = my_ylab) +
    climateAnalyzeR_theme

  return(gg)
}


#' Departure Figure
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
#'   dplyr::left_join(
#'     data.frame('month' = 1:12,
#'                'month_abb' = factor(month.abb, levels = month.abb))
#'     )
#'
#' # Plot data
#' monthly_figure(x_var = dat$month_abb, y_var = dat$tmax_depart,
#'                year_group = dat$year, y_intercept = 0, my_year = 2020,
#'                line_color = "red3",
#'                my_title = "TMAX Montly Departure, Hovenweep National Monument",
#'                my_ylab = "Departure (deg F)")
#'
departure_figure <- function(x_var, y_var, year_group, y_intercept, my_year,
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
