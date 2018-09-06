#' Extracts geo location (i.e., longitude/latitude) of reviewers location
#' 
#' @param dsin Input dataset with user location
#' @param user_location User location (e.g., Brussels, Belgium) 
#' 
#' @author Awash Analytics (March 2017)
#' 
#' 

get_geoLocation <- function (dsin = NULL, 
                             user_location = NULL) {
  
  ## --------------------- ##
  ## Data filtering.       ##
  ## --------------------- ##
  ## get the main variable of interest
  locations_all <- dsin %>% 
    dplyr::pull(user_location)
  
  ## make them unique
  locations_uniq <- unique(locations_all)
  
  ## ------------------------------------------------------------ ##
  ## get geo location value (i.e., lon/lat) using Google API.     ##
  ## ------------------------------------------------------------ ##
  geo_res <- data.frame(a = character(), b = numeric(), c = numeric(), 
                        d = character(), e = character())
  
  for (place in locations_uniq) {
    
    ## get lon/lat value
    geo_val <- ggmap::geocode(location = place)
    
    ## ------------------------- ##
    ## get city/country info.    ##
    ## ------------------------- ##
    if ( !is.na(geo_val$lon) | !is.na(geo_val$lat) ) {
      
      ## get city/country info
      revGeo_val <- ggmap::revgeocode(location = c(geo_val$lon, geo_val$lat), 
                                      output = "more")
      
      ## Get city
      city_temp <- as.character(revGeo_val$locality)
      
      if ( !purrr::is_empty(city_temp) ) {           ## evaluate empty character variable in R
        city <- city_temp
      } else {
        city <- "NA"
      }
      
      ## Get country
      country_temp <- as.character(revGeo_val$country)
      
      if ( !purrr::is_empty(country_temp) ) {
        country <- country_temp
      } else {
        country <- "NA"
      }
    } 
    else {
      ## fetching for lon/lat was not successful
      city <- "NA"
      country <- "NA"
    }
    
    ## combine results
    geo_val <- cbind(place, geo_val, city, country)
    
    geo_res <- rbind(geo_res, geo_val)
  }
  
  ## Modify column names
  geo_res <- as.data.frame(geo_res)
  colnames(geo_res) <- c(user_location, 
                         paste("lon", "_", user_location, sep = ""), 
                         paste("lat", "_", user_location, sep = ""),
                         "city", "country")
  
  ## Change factor variables to character, if required
  geo_res_final <- geo_res %>% 
    dplyr::mutate_if(is.factor,as.character)
  
  return(geo_res_final)
}