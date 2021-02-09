<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
library("tidyr")
library("XML")

# Import annual weather data.
<<<<<<< HEAD
=======
import_annual("canyonlands_theneck", 1980, 2020) %>%
  dplyr::select(-dplyr::contains("missing"))

# Import daily weather data
import_daily("hans_flat_rs", 2010, 2020)

# Import monthly departures
import_monthly_depart('natural_bridges_nm', 2000, 2010)

# Import montly weather data
import_montly_wx('canyonlands_theneedle', 2000, 2010)
=======
library("climateAnalyzeR")

# Import annual weather data.
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
import_annual("canyonlands_theneck", 1980, 2020, convert = TRUE)
import_annual("canyonlands_theneck", 1980, 2020, remove_missing = FALSE)

# Import daily weather data
import_daily("hans_flat_rs", 2010, 2020, convert = TRUE)

# Import monthly departures
import_monthly_depart('natural_bridges_nm', 2000, 2010)
import_monthly_depart('natural_bridges_nm', 2000, 2010, convert = TRUE)

# Import montly weather data
import_montly_wx('canyonlands_theneedle', 2000, 2010, convert = TRUE)
<<<<<<< HEAD
#' # Import weather data for June
=======
>>>>>>> master
# Import weather data for June
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
import_montly_wx('hovenweep_utah', 2000, 2010, month = 6)

#' # Import water balance data with soil water capacity set to 100 and using the
#' # Hamon model.
import_water_balance("arches", 2015, 2020, table_type = "monthly",
                     soil_water = 100, pet_type = "hamon",
                     forgiving = "very")
<<<<<<< HEAD
#' # Adjust the soil water capacity to 50 mm and use the Penman Montieth model.
import_water_balance("arches", 2015, 2020, table_type = "daily",
=======
# Adjust the soil water capacity to 50 mm and use the Penman Montieth model.
<<<<<<< HEAD
import_water_balance("arches", 2015, 2020, table_type = "monthly",
=======
import_water_balance("arches", 2015, 2020, table_type = "daily",
>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
                     soil_water = 50, pet_type = "Penman_Montieth",
                     forgiving = "very")

#-- import_data() wrapper function
# Import annual weather data.
<<<<<<< HEAD
=======
<<<<<<< HEAD
import_data("annual_wx", "canyonlands_theneck", 1980, 2020) %>%
  dplyr::select(-dplyr::contains("missing"))

# Import daily weather data
import_data("daily_wx", "hans_flat_rs", 2010, 2020)

# Import monthly departures
import_data("monthly_depart", 'natural_bridges_nm', 2000, 2010)
=======
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, convert = TRUE)
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, remove_missing = TRUE)

# Import daily weather data
import_data("daily_wx", "hans_flat_rs", 2010, 2020, convert = TRUE)

# Import monthly departures
import_data("monthly_depart", 'natural_bridges_nm', 2000, 2010, convert = TRUE)
<<<<<<< HEAD
=======
>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3

# Import montly weather data
import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010, convert = TRUE)
# Import weather data for June
<<<<<<< HEAD
import_data("monthly_wx", 'hovenweep_utah', 2000, 2010, month = 6)
=======
<<<<<<< HEAD
import_data("monthly_wx", 'hovenweep_utah', 2000, 2010, month = 6)
=======
import_data("monthly_wx", 'hovenweep_utah', 2000, 2010, month = 6, convert = TRUE)
>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3

# Import water balance data with soil water capacity set to 100 and using the
# Hamon model.
import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
            soil_water = 100, pet_type = "hamon", forgiving = "very")
# Adjust the soil water capacity to 50 mm and use the Penman Montieth model.
<<<<<<< HEAD
import_data("water_balance", "arches", 2015, 2020, table_type = "daily",
            soil_water = 50, pet_type = "Penman_Montieth", forgiving = "very")
=======
<<<<<<< HEAD
import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
            soil_water = 50, pet_type = "Penman_Montieth", forgiving = "very")
=======
import_data("water_balance", "arches", 2015, 2020, table_type = "daily",
            soil_water = 50, pet_type = "Penman_Montieth", forgiving = "very")

>>>>>>> master
>>>>>>> 3356fcdde2e2b322660fbeba63d5f5638274d0e3
