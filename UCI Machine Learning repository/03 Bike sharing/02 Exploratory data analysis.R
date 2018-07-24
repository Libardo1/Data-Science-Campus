
#####################
## load library
#####################
source("./03 R programs/load library.R")

####################################
## Import main analysis dataset
####################################
## Import dataset
data <- readr::read_rds(path = "./02 Analysis dataset/bSharing_day_cnt.rds")

## Check variable type
str(data)

##################################
## Exploratory data analysis
##################################
## Summary stat
summary(data[,-13])           ## No missing dataset was found in the dataset

## --------------------
## Visualization
## --------------------
## Plot for all variables
GGally::ggpairs(data = data[,-13])

## Plot for numeric features
cnt <- data %>%
  dplyr::select(cnt, id)

data_num <- data %>% 
  dplyr::select_if(is.numeric)

GGally::ggpairs(data = data_num[,-6])

## Plot for categorical features
data_categorical <- data %>%
  dplyr::select_if(is.factor) %>% 
  dplyr::mutate(id = row_number())

data_categorical <- data_categorical %>% 
  dplyr::inner_join(cnt, by = c('id' = 'id'))

GGally::ggpairs(data = data_categorical[,-8])




