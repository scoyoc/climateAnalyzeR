## code to prepare `month_df` dataset goes here
# Create a data frame of months.
month_df <- data.frame(month = 1:12,
                       water_month = c(4:12, 1:3),
                       month_name = factor(month.abb,
                                        levels = c(month.abb[10:12],
                                                   month.abb[1:9])),
                       season = c("Wi", "Wi", "Sp", "Sp", "Sp", "Su", "Su",
                                  "Su", "Fa", "Fa", "Fa", "Wi"))

usethis::use_data(month_df, overwrite = TRUE)
