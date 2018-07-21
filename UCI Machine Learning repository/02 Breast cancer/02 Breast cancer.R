
###################################################
## Step 0. load library and custom functions
###################################################
source("./03 R programs/load library.R")

##########################################
## Step 1. Import analysis dataset
##########################################
# breast_cancer <- readr::read_csv(file = file.choose(), col_names = T)

breast_cancer <- readr::read_rds(path = file.choose())

str(breast_cancer)




