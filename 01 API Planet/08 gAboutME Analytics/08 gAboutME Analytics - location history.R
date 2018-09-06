
###########################################
## load library and custom functions
###########################################
source("./03 R programs/load library.R")

###########################################################
## Session 1. Analyze location data
## --------------------------------------------------------
## source data: ./Takeout_20170717/Location History/
###########################################################

## ------------------------------------
## 1.1. Import JSON raw location dataset
## ------------------------------------
# location_history_raw <- rjson::fromJSON(json_str = file.choose())

location_history_raw <- jsonlite::fromJSON(txt = file.choose(), simplifyDataFrame = T)
location_history <- location_history_raw$locations %>% 
  dplyr::as_data_frame()

## ---------------------------------------
## 1.2. Preprocess location raw dataset
## ---------------------------------------
location_history_prep <- location_history %>% 
  dplyr::select(timestampMs, latitudeE7, longitudeE7) %>% 
  dplyr::mutate(date_orig = as.POSIXct(as.numeric(timestampMs)/1000, origin="1970-01-01")) %>%      ## source: https://shiring.github.io/maps/2016/12/30/Standortverlauf_post
  dplyr::mutate(date = as.Date(unlist(stringr::str_extract(string = date_orig, 
                                                           pattern = "\\d+\\-\\d+\\-\\d+[^\\s+]")))) %>% 
  dplyr::mutate(year = lubridate::year(date)) %>% 
  dplyr::mutate(month = lubridate::month(date)) %>% 
  dplyr::mutate(day = lubridate::day(date)) %>% 
  dplyr::mutate(lat = latitudeE7/1e7) %>%                   ## convert geolaction from E7 to GPS coordinates (source: https://shiring.github.io/maps/2016/12/30/Standortverlauf_post)
  dplyr::mutate(lon = longitudeE7/1e7)

## ---------------------------------------
## 1.3. Visualization
## ---------------------------------------
## 1.3a. Visualization of location history in Europe
## source: https://shiring.github.io/maps/2016/12/30/Standortverlauf_post
holland <- ggmap::get_map(location = 'Netherlands', zoom = 5)

ggmap(holland) + geom_point(data = location_history_prep, 
                            aes(x = lon, y = lat), alpha = 0.5, color = "red") + 
  theme(legend.position = "right") + 
  labs(
    x = "Longitude", 
    y = "Latitude", 
    title = "Location history data points in Europe",
    caption = "\nA simple point plot shows recorded positions.")

## 1.3b. Visualization of location history in Holland
holland_city <- ggmap::get_map(location = 'Netherlands', zoom = 7)

ggmap(holland_city) + geom_point(data = location_history_prep, 
                                 aes(x = lon, y = lat), alpha = 0.5, color = "red") + 
  theme(legend.position = "right") + 
  labs(
    x = "Longitude", 
    y = "Latitude", 
    title = "Location history data points in Holland",
    caption = "\nA simple point plot shows recorded positions.")




