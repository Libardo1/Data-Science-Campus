
###################
## load library
###################
source("./03 R programs/load library.R")
source("./03 R programs/get_geoLocation.R")

##########################
## Import raw dataset
##########################
# data_raw <- readr::read_csv(file = file.choose(), col_names = T)
data_raw <- read.csv(file = file.choose(), header = T, sep = ';')

##############################################
# Get geolocation for citites in Uganda
##############################################
## Connect to Google location API
google_api <- readLines(con = file.choose())
ggmap::register_google(key = google_api)

## Get geolocation from Google
data_geolocation <- get_geoLocation(dsin = data_raw,
                                    user_location = "Area")

## Validate geolocation
## -- Finding: There are 4 citites 
## ------------------------------------------------------------
## Area   lon_Area   lat_Area        city       country
## ------------------------------------------------------------
## 1 Busia   34.11146  0.4607691       Busia         Kenya
## 2 Jinja  -95.67707 37.0625000 Coffeyville United States
## 3  Kumi -115.17690 36.0915381   Las Vegas United States
## 4  Apac  -95.86623 36.1024780       Tulsa United States
## ------------------------------------------------------------
##
## Thus, assign geolocation manually as shown below
## - source: 1. https://en.wikipedia.org/wiki/Busia,_Uganda
##           2. https://latitude.to/map/ug/uganda/cities/apac
## ------------------------------------------------------------
## Busia: Latitude:0.4669; Longitude:34.0900
## Jinja: Latitude: 0.4390 Longitude: 33.2032
## Kumi: Latitude:1.493334; Longitude:33.937500
## Apac: Latitude: 1.9756 Longitude: 32.5386
data_geolocation %>% dplyr::filter(country != 'Uganda')

data_geolocation_miscalculated <- data.frame(cbind(Area = c('Busia', 'Jinja', 'Kumi', 'Apac'),
                                                   lon_Area = c(34.0900, 33.2032, 33.937500, 32.5386),
                                                   lat_Area = c(0.4669, 0.4390, 1.493334, 1.9756)
                                                   , city = c('Busia', 'Jinja', 'Kumi', 'Apac')
                                                   , country = c('Uganda', 'Uganda', 'Uganda', 'Uganda')
                                                   ), stringsAsFactors = F)

data_geolocation_miscalculated <- data_geolocation_miscalculated %>% 
  dplyr::mutate(lon_Area = as.numeric(lon_Area)) %>% 
  dplyr::mutate(lat_Area = as.numeric(lat_Area))

## Get final geolocation
data_geolocation_prep <- data_geolocation %>% 
  dplyr::filter(country == 'Uganda')

data_geolocation_final <- dplyr::bind_rows(data_geolocation_prep, 
                                           data_geolocation_miscalculated)

## Save geolocation dataset
readr::write_csv(x = data_geolocation_final, 
                 path = "./02 Analysis dataset/data_geolocation_uganda.csv", 
                 col_names = T)




