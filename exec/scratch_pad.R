devtools::install_github("scoyoc/climateAnalyzeR")
library("climateAnalyzeR")

# TODO: Write dynamic text for current water year.
# TODO: Write dynamic text when data are insufficient.
# TODO: Include water balance in summary.
# TODO: add measurement to imperial units and replace them with metric when converting.

#-- Package development
# Delete NAMESPACE file and man directory
file.remove("NAMESPACE")
unlink("man", recursive = T)
# Create new NAMESPACE file and man directory
devtools::document()
devtools::check()
devtools::load_all()

#-- Annual data
# Import annual temperature and precipitation data and convert values to metric
import_annual("canyonlands_theneck", 1980, 2020, convert = TRUE)
# Import annual temperature and precipitation data and remove columns of missing
# values tally.
import_annual("canyonlands_theneck", 1980, 2020, remove_missing = FALSE)

#-- Daily data
# Import daily temperature and precipitation data
import_daily("hans_flat_rs", 2010, 2020)
# Import daily temperature and precipitation data and convert values to metric
import_daily("hans_flat_rs", 2010, 2020, convert = TRUE)

#-- Monthly departures
# Import monthly departures and convert values to metric
import_departure('natural_bridges_nm', 2000, 2010, convert = TRUE)
# Import departures for the month of July
import_departure('natural_bridges_nm', 2000, 2010, month = 7)

#-- Monthly data
# Import monthly precipitation and temperature data and convert values to metric
import_monthly('canyonlands_theneedle', 2000, 2010, convert = TRUE)
# Import monthly precipitation and temperature data for the month of June
import_monthly('canyonlands_theneedle', 2000, 2010, month = 6)

#-- Water balance data
# Import monthly water balance data using the Hamon model with soil water
# capacity set to 100.
import_water_balance("arches", 2015, 2020, table_type = "monthly",
                     soil_water = 100, pet_type = "hamon",
                     forgiving = "very")
# Import daily water balance data using the Hamon model with soil water
# capacity set to 50
import_water_balance("arches", 2015, 2020, table_type = "daily",
                     soil_water = 50, pet_type = "Penman_Montieth",
                     forgiving = "very")

#-- import_data() wrapper function
#-- Annual data
# Import annual temperature and precipitation data and convert values to metric
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, convert = TRUE)
# Import annual temperature and precipitation data and remove columns of missing
# values tally.
import_data("annual_wx", "canyonlands_theneck", 1980, 2020, remove_missing = FALSE)

#-- Daily data
# Import daily temperature and precipitation data
import_data("daily_wx", "hans_flat_rs", 2010, 2020)
# Import daily temperature and precipitation data and convert values to metric
import_data("daily_wx", "hans_flat_rs", 2010, 2020, convert = TRUE)

#-- Monthly departures
# Import monthly departures and convert values to metric
import_data("departure", 'natural_bridges_nm', 2000, 2010, convert = TRUE)
# Import departures for the month of July
import_data("departure", 'natural_bridges_nm', 2000, 2010, month = 7)

#-- Monthly data
# Import monthly precipitation and temperature data and convert values to metric
import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010, convert = TRUE)
# Import monthly precipitation and temperature data for the month of June
import_data("monthly_wx", 'canyonlands_theneedle', 2000, 2010, month = 6)

#-- Water balance data
# Import monthly water balance data using the Hamon model with soil water
# capacity set to 100.
import_data("water_balance", "arches", 2015, 2020, table_type = "monthly",
            soil_water = 100, pet_type = "hamon", forgiving = "very")
# Import daily water balance data using the Hamon model with soil water
# capacity set to 50
import_data("water_balance", "arches", 2015, 2020, table_type = "daily",
            soil_water = 50, pet_type = "Penman_Montieth", forgiving = "very")

#--- Testing ---

#-- Water balance data
# Failed water balance query
import_data("water_balance", "arches", 2010, 2020, table_type = "monthly",
            soil_water = 100, pet_type = "hamon", forgiving = "very")

normals()
#' # 1981-2010 normals for Arches National Park
normals(my_stations = "capitol_reef_np")
#' # 1971-2000 normals for Arches National Park
normals(ref_period = "1971-2000", my_stations = c("blue_mesa_lake", "cimarron", "black_canyon_of_the_gunnison"))

#' # Import all information for all stations.
stations()
#' # Filter station by name
stations(my_stations = "colorado_nm")$name
stations(my_stations = c("dinosaur_nm", "dinosaur_quarry_area"))


renderSummary(station_id = "arches",
              station_name = "Arches National Park",
              my_year = 2020)

