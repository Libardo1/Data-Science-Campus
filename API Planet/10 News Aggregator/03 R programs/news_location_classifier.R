
news_location_classifier <- function (data = NULL) {
  
  #######################################################################################################
  ## Inspired by:
  ## - https://stackoverflow.com/questions/5318076/extracting-country-name-from-author-affiliations
  #######################################################################################################
  myFunc <- function(news_column = NULL,
                     is_city = TRUE) {
    
    # location_input <- stringr::str_to_title(string = data$description) %>%
    location_input <- stringr::str_to_title(string = news_column) %>%
      # location_input <- stringr::str_to_title(string = qwe2) %>% 
      stringr::str_replace_all(pattern = "[[:punct:]]", replacement = "") %>%
      stringr::str_split(pattern = " ")
    
    if (!is_city) {
      location <- plyr::llply(.data = location_input,
                              .fun = function(x)x[max(which(x %in% maps::world.cities$country.etc))]) %>% 
        unlist() %>% 
        as.character()
    }
    else {
      location <- plyr::llply(.data = location_input,
                              .fun = function(x)x[max(which(x %in% maps::world.cities$name))]) %>% 
        unlist() %>% 
        as.character()
    }
    
    return(location)
  }
  
  ## Derive location (e.g., city and country)
  data <- data %>% 
    dplyr::mutate(city = myFunc(news_column = description)) %>% 
    dplyr::mutate(country = myFunc(news_column = description, is_city = FALSE))
  
  
}