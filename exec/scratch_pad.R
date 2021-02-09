library("climateAnalyzeR")

# Import annual weather data.
import_annual("canyonlands_theneck", 1980, 2020, convert = TRUE)
import_annual("canyonlands_theneck", 1980, 2020, remove_missing = FALSE)

# Import daily weather data
import_daily("hans_flat_rs", 2010, 2020)
import_daily("hans_flat_rs", 2010, 2020, convert = TRUE)

# Import monthly departures
import_monthly_depart('natural_bridges_nm', 2000, 2010)
import_monthly_depart('natural_bridges_nm', 2000, 2010, convert = TRUE)

# Import montly weather data
import_montly_wx('canyonlands_theneedle', 2000, 2010, convert = TRUE)
# Import weather data for June
import_montly_wx('hovenweep_utah', 2000, 2010, month = 6)

# Import water balance data with soil water capacity set to 100 and using the
# Hamon model.
import_water_balance("arches", 2015, 2020, table_type = "monthly",
                     soil_water = 100, pet_type = "hamon",
                     forgiving = "very")
# Adjust the soil water capacity to 50 mm and use the Penman Montieth model.
import_water_balance("arches", 2015, 2020, table_type = "daily",
                     soil_water = 50, pet_type = "Penman_Montieth",
                     forgiving = "very")

#-- import_data() wrapper function
# Import annual weather data.
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, convert = TRUE)
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, remove_missing = FALSE)

# Import daily weather data
import_data("daily_wx", "hans_flat_rs", 2010, 2020)
import_data("daily_wx", "hans_flat_rs", 2010, 2020, convert = TRUE)

# Import monthly departures
import_data("monthly_depart", 'natural_bridges_nm', 2000, 2010)
import_data("monthly_depart", 'natural_bridges_nm', 2000, 2010, convert = TRUE)

# Import montly weather data
import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010)
# Import weather data for June
import_data("monthly_wx", 'hovenweep_utah', 2000, 2010, month = 6, convert = TRUE)

# Import water balance data with soil water capacity set to 100 and using the
# Hamon model.
import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
            soil_water = 100, pet_type = "hamon", forgiving = "very")
# Adjust the soil water capacity to 50 mm and use the Penman Montieth model.
import_data("water_balance", "arches", 2015, 2020, table_type = "daily",
            soil_water = 50, pet_type = "Penman_Montieth", forgiving = "very")



#--- Testing ---

import_monthly_depart('natural_bridges_nm', 2000, 2010)


