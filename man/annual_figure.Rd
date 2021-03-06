% Generated by roxygen2: do not edit by hand
<<<<<<< HEAD
% Please edit documentation in R/annual_figure.R
=======
% Please edit documentation in R/annual_figure.R, R/area_figure.R
>>>>>>> 7221d3cdfa5a09c3102100d3d92a984c9d42c09a
\name{annual_figure}
\alias{annual_figure}
\title{Line Figure with Area}
\usage{
annual_figure(
  x_var,
  y_var,
  normal,
  reference_period,
  area_color,
  line_color,
  my_title,
  my_ylab
)
<<<<<<< HEAD
=======

annual_figure(
  x_var,
  y_var,
  normal,
  reference_period,
  area_color,
  line_color,
  my_title,
  my_ylab
)
>>>>>>> 7221d3cdfa5a09c3102100d3d92a984c9d42c09a
}
\arguments{
\item{x_var}{A character string of hte x-variable.}

\item{y_var}{A character string of the y-variable.}

\item{normal}{A number for the annual normal temperature or precipitation.
Typically derived from \code{\link[climateAnalyzeR::normals]{normals}}.}

\item{reference_period}{Character string for the reference period used for
normals.}

\item{area_color}{A character string for the color of the area. See
\code{\link[grDevices::colors]{colors}} for a list of color names.}

\item{line_color}{A character string for the line color.}

\item{my_title}{A character string for the title.}

\item{my_ylab}{A character string from the y-axis.}
}
\value{
A ggplot object.
<<<<<<< HEAD
=======

A ggplot object.
>>>>>>> 7221d3cdfa5a09c3102100d3d92a984c9d42c09a
}
\description{
This function produces a standardized line graph with colored area under the
line. This figure is used in RMarkdown scrips.
<<<<<<< HEAD
}
\examples{
# TODO: write example
=======

This function produces a standardized line graph with colored area under the
line. This figure is used in RMarkdown scrips.
}
\examples{
# TODO: write example
# TODO: write example
>>>>>>> 7221d3cdfa5a09c3102100d3d92a984c9d42c09a
}
