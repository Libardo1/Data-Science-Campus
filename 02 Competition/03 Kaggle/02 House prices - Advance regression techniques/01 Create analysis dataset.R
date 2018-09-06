
##################################################
## Step 0. Load library and custom functions
##################################################
source("./03 R programs/load library.R")

source("./03 R programs/get_varMetadata.R")
source("./03 R programs/plot_histogram_eda.R")
source("./03 R programs/plot_histogram_eda.R")

#################################################
## Step 1. Import raw dataset and preprocess
#################################################
## ----------------------------------------
## 1.1. Import training and test dataset
## ----------------------------------------
train_raw <- readr::read_csv(file = "./01 Raw dataset/all/train.csv", 
                             col_names = T, col_types = cols())

test_raw <- readr::read_csv(file = "./01 Raw dataset/all/test.csv", 
                            col_names = T, col_types = cols())

## ----------------------------------------------------
## 1.2. Understanding dataset structure and types
## ----------------------------------------------------
str(train_raw)

## 1.2a. Convert character types into factors
train_prep1 <- train_raw %>% 
  dplyr::mutate_if(is.character, as.factor)

test_prep1 <- test_raw %>% 
  dplyr::mutate_if(is.character, as.factor)

str(train_prep1)

# ## 1.2b. Find out which integer variables should be converted into factors
# summary(train_prep1 %>% 
#           dplyr::select_if(is.numeric))
# 
# ## Pairwse scatter plots to understand distribution of variables and to identify outliers
# GGally::ggpairs(data = train_prep1 %>% dplyr::select_if(is.numeric), columns = c(2:10))
# GGally::ggpairs(data = train_prep1 %>% dplyr::select_if(is.numeric), columns = c(11:21))
# GGally::ggpairs(data = train_prep1 %>% dplyr::select_if(is.numeric), columns = c(22:30))
# GGally::ggpairs(data = train_prep1 %>% dplyr::select_if(is.numeric), columns = c(31:38))
# 
# ## Get list of variables with few unique values
# metadata_train <- get_varMetadata(dsin = train_prep1 %>% dplyr::select_if(is.numeric), 
#                                   id_var = 'Id', is_train = TRUE)
# 
# var_toFactor_exceptional <- c('MoSold', 'PoolArea', )
# 
# var_toFactor <- metadata_train %>% 
#   dplyr::filter(flg_toFactor == T) %>% 
#   dplyr::pull(key_variable) %>% 
#   as.character()
# 
# var_toFactor


## 1.3. Use ID variable as row names
## Train dataset
train_prep2 <- train_prep1 %>% 
  dplyr::select(-Id) %>% 
  as.data.frame()

rownames(train_prep2) <- train_prep1$Id

## Test dataset
test_prep2 <- test_prep1 %>% 
  dplyr::select(-Id) %>% 
  as.data.frame()

rownames(test_prep2) <- test_prep1$Id

## 1.4. Save final analysis dataset
train_final <- train_prep2
test_final <- test_prep2

readr::write_rds(x = train_final, path = "./02 Analysis dataset/train_anal.rds")
readr::write_rds(x = test_final, path = "./02 Analysis dataset/test_anal.rds")




