% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/monthly_figure.R
\name{monthly_figure}
\alias{monthly_figure}
\title{Grouped Line Figure}
\usage{
monthly_figure(
  x_var,
  y_var,
  year_group,
  y_intercept,
  my_year,
  line_color,
  my_title,
  my_ylab
)
}
\arguments{
\item{x_var}{A vector of hte x-variable.}

\item{y_var}{A vector of the y-variable.}

\item{year_group}{A vector for the grouping variable.}

\item{y_intercept}{A number for the y-intercept of the reference line. Zero
(0) or 100 are normally used.}

\item{my_year}{A 4-digit year. This variable is used to subset the data
provided by x_var, y_var, and year_group for plotting, and as a label on
the figure.}

\item{line_color}{A character string for the line color.See
\code{\link[grDevices::colors]{colors}} for a list of color names.}

\item{my_title}{A character string for the title.}

\item{my_ylab}{A character string from the y-axis.}
}
\value{
A ggplot object.
}
\description{
This function produces a standardized line graph the is grouped by year. This
figure is used in RMarkdown scrips.
}
