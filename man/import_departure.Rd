% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_departure.R
\name{import_departure}
\alias{import_departure}
\title{Import monthly departure data from ClimateAnalyzer.org into R.}
\usage{
import_departure(
  station_id,
  start_year,
  end_year,
  month = "all",
  norm_per = "1981-2010",
  convert = FALSE
)
}
\arguments{
\item{station_id}{The character string of the station ID.}

\item{start_year}{The four digit number of the first year of interest.}

\item{end_year}{The four digit number of the last year of interest.}

\item{month}{The month number (i.e., 1 for January through 12 for December)
or 'all' for all months. Dafault is 'all'.}

\item{norm_per}{A character string for the 30-year normalization period.
Either '1971-2000' or '1981-2010'. Default is '1981-2010'.}

\item{convert}{Logical. If TRUE, data are precipitation and temperature
values are converted to metric. These converted values are included as
additional columns in the data frame denoted by "_mm" or "_C". Default is
FALSE.}
}
\value{
A \code{\link[tibble:tibble]{tibble}}.
}
\description{
This function imports monthly departure data from
\href{http://www.climateanalyzer.org/}{ClimateAnalyzer.org} into R.
}
\examples{
# Import monthly departures and convert values to metric
import_departure('natural_bridges_nm', 2000, 2010, convert = TRUE)
# Import departures for the month of July
import_departure('natural_bridges_nm', 2000, 2010, month = 7)
}
\seealso{
The \code{\link{import_data}} wrapper function.
}
