
###############################################################################################################################
## Inspired by: Steven Slezak (http://rstudio-pubs-static.s3.amazonaws.com/171872_ab8dd184af0e4b2cbe3469b2c75b0093.html)
## -- Data source (German credit dataset): https://onlinecourses.science.psu.edu/stat857/node/215/
###############################################################################################################################

## -----------------------------------------------
## Step 0. load library and custom programs
## -----------------------------------------------
source("./03 R programs/load library.R")
source("./03 R programs/get_varMetadata.R")
source("./03 R programs/preprocess_varTypes.R")
source("./03 R programs/plot_histogram_eda.R")
source("./03 R programs/plot_association_eda.R")

## -----------------------------------------------------
## Step 1. load raw credit dataset and dictionary
## -----------------------------------------------------
# german_credit_data_raw <- readr::read_csv(file = "./01 Raw dataset/German credit data.csv", 
#                                           col_names = T)

## ------------------------
## Import training set
## ------------------------
german_credit_data_train_raw <- readr::read_csv(file = "./01 Raw dataset/German credit data_training50.csv", 
                                                col_names = T)

## Rename X1 column
german_credit_data_train_raw <- german_credit_data_train_raw %>% 
  dplyr::mutate(id = X1) %>% 
  dplyr::select(-X1)

## --------------------
## Import test set
## --------------------
german_credit_data_test_raw <- readr::read_csv(file = "./01 Raw dataset/German credit data_test.csv", 
                                               col_names = T)

## Rename X1 column
german_credit_data_test_raw <- german_credit_data_test_raw %>% 
  dplyr::mutate(id = X1) %>% 
  dplyr::select(-X1)

## -----------------------------------------------------
## Step 2. Preprocessing (or Data wrangling)
## -----------------------------------------------------
## ---------------------------------
## 2.1. Cleaning column names 
## ---------------------------------
str(german_credit_data_train_raw)

## Removes dots from column names - training dataset
colnames_train_orig <- colnames(german_credit_data_train_raw)
colnames_train_mdf <- stringr::str_replace_all(colnames_train_orig, 
                                               pattern = "\\.", 
                                               replacement = "")
colnames(german_credit_data_train_raw) <- colnames_train_mdf

## Removes dots from column names - test dataset
colnames_test_orig <- colnames(german_credit_data_test_raw)
colnames_test_mdf <- stringr::str_replace_all(colnames_test_orig, 
                                              pattern = "\\.", 
                                              replacement = "")
colnames(german_credit_data_test_raw) <- colnames_test_mdf

## ------------------------------------------------
## 2.2. Determin factor vs numeric columns
## ------------------------------------------------
## Get variable metadata for training set
metadata_variable_train <- get_varMetadata(dsin = german_credit_data_train_raw, 
                                           id_var = "id", 
                                           is_train = T)

## Get variable metadata for test set
metadata_variable_test <- get_varMetadata(dsin = german_credit_data_test_raw, 
                                          id_var = "id", 
                                          is_train = F)

## Adjust variable class type 
train <- preprocess_varTypes(dsin = german_credit_data_train_raw, 
                             metadata_variable = metadata_variable_train)

test <- preprocess_varTypes(dsin = german_credit_data_test_raw, 
                            metadata_variable = metadata_variable_test)

## --------------------------------------------------------------
## Step 4. Check if any of factor variables has single level
## --------------------------------------------------------------
## Result: Occupation
which(sapply(train, function(x) { length(unique(x)) }) == 1)       ## source: https://stackoverflow.com/questions/44200195/how-to-debug-contrasts-can-be-applied-only-to-factors-with-2-or-more-levels-er     

## Result: Occupation
which(sapply(test, function(x) { length(unique(x)) }) == 1)        ## source: https://stackoverflow.com/questions/44200195/how-to-debug-contrasts-can-be-applied-only-to-factors-with-2-or-more-levels-er     

## remove Occupation variable
train_final <- train %>% 
  dplyr::select(-Occupation)

test_final <- test %>% 
  dplyr::select(-Occupation)

## ---------------------------------------------------
## Step 4. Check a need for transformation
## ---------------------------------------------------
plot_histogram_eda(dsin = train_final,
                   metadata_variable = metadata_variable_train, 
                   id_var = "id")

plot_histogram_eda(dsin = test_final,
                   metadata_variable = metadata_variable_test, 
                   id_var = "id")

## Decision: CreditAmount should be transformed
## -- training set
train_final_transf <- train_final %>% 
  dplyr::mutate(ln_CreditAmount = log(CreditAmount)) %>% 
  dplyr::select(-CreditAmount)

plot_histogram_eda(dsin = train_final_transf,
                   metadata_variable = metadata_variable_train, 
                   id_var = "id")

## -- test set
test_final_transf <- test_final %>% 
  dplyr::mutate(ln_CreditAmount = log(CreditAmount)) %>% 
  dplyr::select(-CreditAmount)

plot_histogram_eda(dsin = test_final_transf,
                   metadata_variable = metadata_variable_test, 
                   id_var = "id")

## ---------------------------------------------------
## Step 5. Check for outliers
## ---------------------------------------------------
## Conclusion: no need for transformation for interval variables
plot_association_eda(dsin = train_final_transf, 
                     response_var = "Creditability", 
                     plot_type = "boxplot", 
                     id_var = "id")

## Conclusion: no need for transformation for factor variables
plot_association_eda(dsin = train_final_transf, 
                     response_var = "Creditability", 
                     plot_type = "barplot", 
                     id_var = "id")

## ---------------------------------------------------
## Step 6. Save analysis dataset and its metadat
## ---------------------------------------------------
## Save training set
readr::write_rds(x = train_final_transf, path = "./02 Analysis dataset/train.rds")
readr::write_csv(x = metadata_variable_train, path = "./02 Analysis dataset/metadata_variable_train.csv", 
                 col_names = )

## Save test set
readr::write_rds(x = test_final_transf, path = "./02 Analysis dataset/test.rds")
readr::write_csv(x = metadata_variable_test, path = "./02 Analysis dataset/metadata_variable_test.csv", 
                 col_names = T)
