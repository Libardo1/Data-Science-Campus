###################################################
## Step 0. load library and custom functions
###################################################
source("./03 R programs/load library.R")

#############################
## Step 1. Load dataset
#############################
breast_cancer_raw <- readr::read_csv(file = file.choose(), col_names = T)

######################################
## Step 2. Preprocess raw dataset
######################################
## Check variable type
str(breast_cancer_raw)

## Change all character variables to factors. And, change deg_malig variable 
## from integer to factor
breast_cancer_prep <- breast_cancer_raw %>% 
  dplyr::mutate_if(is.character, as.factor) %>% 
  dplyr::mutate(deg_malig = factor(deg_malig))

str(breast_cancer_prep)

## Modify missing value indicator (from ? to NA)
summary(breast_cancer_prep)

breast_cancer_prep2 <- breast_cancer_prep %>% 
  dplyr::rename(node_caps_raw = node_caps) %>% 
  dplyr::mutate(node_caps = factor(ifelse(node_caps_raw == "?", NA, node_caps_raw))) %>% 
  dplyr::select(-node_caps_raw) %>% 
  dplyr::rename(breast_quad_raw = breast_quad) %>% 
  dplyr::mutate(breast_quad = factor(ifelse(breast_quad_raw == "?", NA, breast_quad_raw))) %>% 
  dplyr::select(-breast_quad_raw)

summary(breast_cancer_prep2)

## Recode response variable to 0 and 1
breast_cancer_prep3 <- breast_cancer_prep2 %>% 
  dplyr::rename(Class_raw = Class) %>% 
  dplyr::mutate(Class = factor(ifelse(Class_raw == "no-recurrence-events", 0, 1))) %>% 
  dplyr::select(-Class_raw)

summary(breast_cancer_prep3)

## Save analysis dataset
# readr::write_csv(x = breast_cancer_prep3, 
#                  path = "./02 Analysis dataset/breast_cancer_anal_data.csv", col_names = T)

## Save analysis dataset as R dataset to retain variable type
readr::write_rds(x = breast_cancer_prep3, 
                 path = "./02 Analysis dataset/breast_cancer_anal_data.rds")


