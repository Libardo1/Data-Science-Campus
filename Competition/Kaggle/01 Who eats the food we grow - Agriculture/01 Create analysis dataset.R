
############################################
## load library and custom functions
############################################
source("./03 R programs/load library.R")

##########################
## Import raw dataset
##########################
data_raw <- readr::read_csv(file = "./01 Raw dataset/FAO.csv", 
                            col_names = T, col_types = cols())

################################
## Preprocess raw dataset
################################
## Convert dataset from wide to long format (i.e., time series format)
col_remain <- c("Area_Abbreviation", "Area_Code", "Area", "Item_Code",        
                "Item", "Element_Code", "Element", "Unit", "latitude", 
                "longitude")
data_prep1 <- tidyr::gather(data = data_raw, 
                            key = year, value = response, -col_remain)

## Preprocess year value (e.g., from Y1961 -> 1961)
data_prep2 <- data_prep1 %>% 
  dplyr::rename(date_raw = year) %>% 
  dplyr::mutate(date_raw2 = as.character(unlist(stringr::str_extract(string = date_raw, 
                                                                     pattern = "\\d+")))) %>% 
  dplyr::mutate(date = as.Date(paste(date_raw2, '-01-01', sep = ''), 
                               format = '%Y-%m-%d')) %>% 
  dplyr::select(-contains('_raw')) %>% 
  dplyr::mutate(year = lubridate::year(date))

# ## Get Ethiopia dataset
# data_eth <- data_prep2 %>% 
#   dplyr::filter(Area_Abbreviation == 'ETH') %>% 
#   dplyr::filter(!is.na(response))

## Change data structure
data_prep3 <- data_prep2 %>% 
  dplyr::mutate_if(is.character, as.factor)

###############################
## Save analysis dataset
###############################
## Create final dataset
data_final <- data_prep3

## Save final dataset
filename_out <- file.path(paste('./02 Analysis dataset/FAO_anal_', 
                                lubridate::today(), '.rds', sep = ''))
readr::write_rds(x = data_final, path = filename_out)







