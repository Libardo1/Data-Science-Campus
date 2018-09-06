
########################################
## load library and custom functions
########################################
source("./04 R programs/load library.R")

source("./04 R programs/get_varMetadata.R")
source("./04 R programs/plot_histogram_eda.R")
source("./04 R programs/plot_association_eda.R")

############################
## Import raw dataset 
############################
## Train raw dataset
train_values_orig <- readr::read_csv(file = "./01 Raw dataset/train_values.csv", 
                                     col_names = T, col_types = cols())
train_labels_orig <- readr::read_csv(file = "./01 Raw dataset/train_labels.csv", 
                                     col_names = T, col_types = cols())

## Test dataset
test_orig <- readr::read_csv(file = "./01 Raw dataset/test_values.csv", col_names = T)

## combine datasets
train_orig <- train_values_orig %>% 
  dplyr::inner_join(train_labels_orig, by = c('patient_id' = 'patient_id')) %>% 
  dplyr::select(-patient_id)

## Understand data structure
str(train_orig)
summary(train_orig)

## Adjust data structure
col_toFactor <- c("slope_of_peak_exercise_st_segment", "chest_pain_type",
                  "num_major_vessels", "fasting_blood_sugar_gt_120_mg_per_dl",
                  "resting_ekg_results", "sex", "exercise_induced_angina",
                  "heart_disease_present")

train_orig_prep1 <- train_orig %>% 
  dplyr::mutate_if(is.character, as.factor) %>%
  dplyr::mutate_each_(funs(factor(.)),
                      col_toFactor)   %>%          ## Coerce multiple columns to factors at once (source: https://stackoverflow.com/questions/33180058/coerce-multiple-columns-to-factors-at-once)
  as.data.frame()

## Check data structure
summary(train_orig_prep1)

## Use patient_id as rownames
rownames(train_orig_prep1) <- train_values_orig$patient_id

#########################################
## Check for possible transformation
#########################################
## Get metadata
metadata_train <- get_varMetadata(dsin = train_orig_prep1, 
                                  id_var = 'patient_id', is_train = T)

## Check for possible transformation
plot_histogram_eda(dsin = train_orig_prep1, 
                   metadata_variable = metadata_train, id_var = 'patient_id')



## Save final training dataset for later use
readr::write_rds(x = train_orig_prep1, path = "./03 Analysis dataset/train_anal.rds")

######################################################
## Do the same for Test dataset - preprocessing
######################################################
col_toFactor_test <- c("slope_of_peak_exercise_st_segment", "chest_pain_type",
                       "num_major_vessels", "fasting_blood_sugar_gt_120_mg_per_dl",
                       "resting_ekg_results", "sex", "exercise_induced_angina")

test_orig_prep1 <- test_orig %>% 
  dplyr::mutate_if(is.character, as.factor) %>%
  dplyr::mutate_each_(funs(factor(.)),
                      col_toFactor_test)   %>%          ## Coerce multiple columns to factors at once (source: https://stackoverflow.com/questions/33180058/coerce-multiple-columns-to-factors-at-once)
  dplyr::select(-patient_id) %>% 
  as.data.frame()

## Check data structure
summary(test_orig_prep1)

## Use patient_id as rownames
rownames(test_orig_prep1) <- test_orig$patient_id

## Save final test dataset for later use
readr::write_rds(x = test_orig_prep1, path = "./03 Analysis dataset/test_anal.rds")


###############
## EDA
###############
## All variables
GGally::ggpairs(data = train_orig_prep1)

## Only numeric variables
GGally::ggpairs(data = train_orig_prep1 %>% 
                  dplyr::select_if(is.numeric) %>% 
                  dplyr::mutate(heart_disease_present = train_orig_prep1$heart_disease_present))

## Only factor variables
GGally::ggpairs(data = train_orig_prep1 %>% 
                  dplyr::select_if(is.factor) %>% 
                  dplyr::mutate(heart_disease_present = train_orig_prep1$heart_disease_present))
