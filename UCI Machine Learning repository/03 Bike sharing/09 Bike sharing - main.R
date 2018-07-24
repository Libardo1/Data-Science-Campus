
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