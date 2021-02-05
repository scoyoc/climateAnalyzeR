# Create error messages
missing_arg <- function(my_arg, my_mess) {
  if(missing(my_arg)){
    message(my_mess)
    stop()
  }
}

#-- Functions to pull data from ClymateAnalyser.org
# comma delimited data
pull_csv <- function(my_url, skip){
  dat = suppressMessages(
    suppressWarnings(
      utils::read.csv(my_url, header = TRUE, na = "nan", skip = skip)
    )
  )
  dat = dat[, !sapply(dat, function(x) sum(is.na(x))) == nrow(dat)]
  return(dat)
}

# scrape HTML tables
pull_xml <- function(my_url, skip){
  dat = XML::readHTMLTable(my_url, skip.rows = skip)[[1]]
  colnames(dat) = as.vector(XML::readHTMLTable(my_url)[[1]][2, ])
  return(tibble::as_tibble(dat))
}
