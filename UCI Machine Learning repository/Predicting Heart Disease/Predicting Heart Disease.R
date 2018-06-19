
#######################
## load library
#######################
source("./03 R programs/load library.R")

###############################
## download UCI dataset
###############################
# source("./03 R programs/download UCI dataset.R")

#####################################################################
## Read combined heart disease dataset
#####################################################################
## location: ./01 Analysis dataset/heart_disease_combined.csv
#####################################################################
heart_disease_combined <- readr::read_csv(file = file.choose(), col_names = T)




