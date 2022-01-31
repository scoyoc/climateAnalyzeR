#' Months of the year.
#'
#' A data set containing month numbers, 3-letter abbreviations, and season. This
#'     data set is imported into the RMarkdown scripts to produce reports.
#'
#' @format A data frame with 12 rows and 4 variables:
#' \describe{
#'   \item{month}{Integer. Calendar year month numbers where Jan is 1 and Dec is
#'       12.}
#'   \item{water_month}{Integer. Water year month number where Oct is 1 and Sep
#'       is 12.}
#'   \item{water_name}{Factor. Abbreviated month name using
#'       \code{\link[month.abb]{month.abb}}. Factor levels correspond to
#'           water_month.}
#'   \item{season}{Character. 2-letter season abbreviation for winter (Wi),
#'       spring (Sp), summer (Su), and fall (Fa).}
#' }
#' @source manual code
"month_df"
