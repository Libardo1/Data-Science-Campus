
##########################################
## load library and custom functions
##########################################
source("./03 R programs/load library.R")

source("./03 R programs/get_varMetadata.R")
source("./03 R programs/plot_association_eda.R")
source("./03 R programs/plot_histogram_eda.R")

## Environmental setting
dir_project <- "./../../../../../../../Google Drive/01 PERSONAL Projects/01 Data Science Campus/06 DS Competitions/00 Driven Data/00 Pump it up_Data Mining the Water Table"

##########################################
## load raw datasets
##########################################
training_noTarget_orig <- readr::read_csv(file = file.choose(), col_names = T)
test_orig <- readr::read_csv(file = file.choose(), col_names = T)
target_training_orig <- readr::read_csv(file = file.choose(), col_names = T)

## Add target variable into training set
training_orig <- training_noTarget_orig %>% 
  dplyr::inner_join(target_training_orig, by = c("id" = "id"))

#####################################################################
## Step 1. Preprocessing 1: Factorization (from char to factor)
#####################################################################
## ---------------------------------
## 1a. Get metadata for variables
## ---------------------------------
metadata_vars_train <- get_varMetadata(dsin = training_orig, id_var = "id", is_train = T)
metadata_vars_test <- get_varMetadata(dsin = test_orig, id_var = "id", is_train = T)

## Save metadata for training set
filename_out <- file.path(paste(dir_project, "/02 Analysis dataset/metadata_vars_train.csv", 
                                sep = ""))
readr::write_csv(x = metadata_vars_train, path = filename_out, col_names = T)

## Save metadata for test set
filename_out <- file.path(paste(dir_project, "/02 Analysis dataset/metadata_vars_test.csv", 
                                sep = ""))
readr::write_csv(x = metadata_vars_test, path = filename_out, col_names = T)

## --------------------------------------------
## 1b. Change variables from char to factor
## --------------------------------------------





# ## Visualization
# tanzania <- ggmap::get_map(location = 'Tanzania', zoom = 3)
# 
# ggmap(tanzania) + geom_point(data = training_orig, 
#                                  aes(x = longitude, y = latitude), alpha = 0.5, color = "red") + 
#   theme(legend.position = "right") + 
#   labs(
#     x = "Longitude", 
#     y = "Latitude"
#     # , title = ""
#     # , caption = ""
#     )
