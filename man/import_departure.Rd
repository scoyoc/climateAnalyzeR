% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_departure.R
\name{import_departure}
\alias{import_departure}
\title{Import monthly departure data}
\usage{
import_departure(
  station_id,
  start_year,
  end_year = NULL,
  month = "all",
  norm_per = "1981-2010",
  convert = FALSE
)
}
\arguments{
\item{station_id}{The character string of the \emph{station_id} field from
\code{\link{stations}}.}

\item{start_year}{The four digit number of the first year of interest.}

\item{end_year}{The four digit number of the last year of interest. Default
is NULL. If NULL, current year will be used.}

\item{month}{A number for the month, 1 for January through 12 for December
or 'all' for all months. Default is 'all'.}

\item{norm_per}{A character string for the 30-year normalization period.
Either '1971-2000', '1981-2010', or '1991-2020'. Default is '1981-2010'.}

\item{convert}{Logical. If TRUE, data are precipitation and temperature
values are converted to metric. These converted values are included as
additional columns in the data frame denoted by "_mm" or "_C". Default is
FALSE.}
}
\value{
A \code{\link[tibble]{tibble}}.
}
\description{
This function imports monthly departure data from
\href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
}
\examples{
library(climateAnalyzeR)

# Import monthly departures
import_departure(station_id = 'natural_bridges_nm', start_year = 2000)

# Import departures for the month of July  and convert values to metric
import_departure(station_id = 'natural_bridges_nm', start_year = 2000,
                 end_year = 2020, month = 7, convert = TRUE)

}
\seealso{
The \code{\link{import_data}} wrapper function.
}
