
#####################
## load library
#####################
source("./03 R programs/load library.R")

###################################
## Step 1. Import raw dataset
###################################
abalone_raw <- readr::read_csv(file = "./01 Raw dataset/abalone_raw.csv", 
                               col_names = T)

###################################
## Step 2. Explore raw dataset
###################################
## ---------------------------
## 2.1. Factor or character
## ---------------------------
str(abalone_raw)
summary(abalone_raw)

## Convert sex into factor
abalone_prep1 <- abalone_raw %>% 
  dplyr::mutate(Sex = factor(Sex))

summary(abalone_prep1)

#######################################
## 2.2. Correlation visualization
#######################################
GGally::ggpairs(data = abalone_prep1)

## Save analysis dataset
readr::write_rds(x = abalone_prep1, path = "./02 Analysis dataset/abalone.rds")