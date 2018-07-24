
#####################
## load library
#####################
source("./03 R programs/load library.R")

#######################################################
## Import and preprocess Bike sharing raw dataset
#######################################################
## Import raw dataset
bSharing_day_raw <- readr::read_csv(file = "./01 Raw dataset/Bike-Sharing-Dataset/day.csv", 
                                    col_names = T)

## Exploratory data analysis
summary(bSharing_day_raw)

## Check variable structure
str(bSharing_day_raw)

## Change some variables from INT to FACTOR
bSharing_day_prep1 <- bSharing_day_raw %>% 
  dplyr::rename(season_raw = season) %>% 
  dplyr::mutate(season = factor(x = season_raw, 
                                levels = c(1,2,3,4), 
                                labels = c('spring', 'summer', 'fall', 'winter'))) %>% 
  dplyr::rename(yr_raw = yr) %>% 
  dplyr::mutate(year = factor(x = yr_raw, 
                              levels = c(0,1), 
                              labels = c('2011', '2012')))  %>% 
  dplyr::rename(mnth_raw = mnth) %>% 
  dplyr::mutate(month = factor(x = mnth_raw))  %>% 
  dplyr::rename(holiday_raw = holiday) %>% 
  dplyr::mutate(holiday = factor(x = holiday_raw, 
                                 levels = c(0,1), 
                                 labels = c('no', 'yes'))) %>% 
  dplyr::rename(weekday_raw = weekday) %>% 
  dplyr::mutate(weekday = factor(weekdays(x = dteday, abbreviate = T))) %>% 
  dplyr::rename(workingday_raw = workingday) %>% 
  dplyr::mutate(workingday = factor(x = workingday_raw, 
                                    levels = c(0,1), 
                                    labels = c('no', 'yes'))) %>% 
  dplyr::rename(weathersit_raw = weathersit) %>% 
  dplyr::mutate(weathersit = factor(x = weathersit_raw)) %>% 
  dplyr::rename(instant_raw = instant) %>% 
  dplyr::mutate(id = instant_raw) %>% 
  dplyr::select(-contains("_raw")) %>% 
  dplyr::select(-dteday)

## Check again variable structure
str(bSharing_day_prep1)

##########################################
## Create final analysis dataset
##########################################
## Create main analysis dataset
bSharing_day_cnt <- bSharing_day_prep1 %>% 
  dplyr::select(-c(casual, registered))

## Create causual analysis dataset
bSharing_day_causual <- bSharing_day_prep1 %>% 
  dplyr::select(-c(cnt, registered))

## Create registered analysis dataset
bSharing_day_registered <- bSharing_day_prep1 %>% 
  dplyr::select(-c(cnt, casual))

## Save all analysis datasets
readr::write_rds(x = bSharing_day_cnt, path = "./02 Analysis dataset/bSharing_day_cnt.rds")
readr::write_rds(x = bSharing_day_causual, path = "./02 Analysis dataset/bSharing_day_causual.rds")
readr::write_rds(x = bSharing_day_registered, path = "./02 Analysis dataset/bSharing_day_registered.rds")

