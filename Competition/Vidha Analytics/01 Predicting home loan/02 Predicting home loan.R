

################################################
## load library and custom functions
################################################
source("./03 R programs/load library.R")

#####################################
## Step 1. Read analysis dataset
#####################################
## Read analysis dataset
train_orig_raw <- readr::read_csv(file = "./02 Analysis dataset/train.csv")
test_orig_raw <- readr::read_csv(file = "./02 Analysis dataset/test.csv")

#####################################################################################
## Step 2. Preprocess analysis dataset for fitting Machine Learning (ML) models
#####################################################################################

## ---------------------------------------------------
## 2a. Drop ID variables and rename target variable
## ---------------------------------------------------
train_orig <- train_orig_raw %>% 
  dplyr::select(-Loan_ID) %>% 
  dplyr::rename(target = Loan_Status)

test_orig <- test_orig_raw %>% 
  dplyr::select(-Loan_ID)

## ----------------------------------------------------------------------------------
## 2b. Create training and test sets from original training dataset (train_orig)
## ----------------------------------------------------------------------------------
## Get index used for data partition
set.seed(pi)
index_train <- caret::createDataPartition(y = train_orig$Loan_Status, 
                                          p = 0.75, 
                                          list = F)

## Determine training and test dataset
ds_train <- train_orig[index_train, ]
ds_test <- train_orig[-index_train, ]

# ## Convert to matrix
# train_matrix <- as.matrix(model.matrix(object = target ~ ., data = ds_train)[, -1])
# target <- ds_train %>% 
#   dplyr::pull(target)

## Create test dataset without target variable
## - This dataset will be used later to predict target variable and 
##   to calculate confusion matrix
my_newdata <- ds_test %>% 
  dplyr::select(-target)

target_observed <- ds_test %>% 
  dplyr::pull(target)

## -----------------------------------
## 2c. Define trControl variable
## -----------------------------------
# my_trControl <- caret::trainControl(method = "cv", 
#                                     number = 10, 
#                                     savePredictions = T)  ## "cv" = cross-validation, 10-fold

my_trControl <- caret::trainControl(method = "repeatedcv", 
                                    number = 5, 
                                    savePredictions = T)  ## "cv" = cross-validation, 10-fold


#############################
## 3. Fit ML models
#############################
## ---------------------------------------------
## 3a. Fit Logistic Regression (LR) model
## - Bug2Fix, 14-jul-18:
##   - Something is wrong; all the Accuracy metric values are missing:
##     - In addition: Warning messages:
##       1: model fit failed for Fold1.Rep1: parameter=none Error in glm.fit(x = structure(c(1, 1, 1, 
## ---------------------------------------------
set.seed(pi)

fit_glm <- caret::train(target ~ .,
                        data = ds_train,
                        method = "glm",
                        family = binomial
                        , trControl = my_trControl
                        # , trControl = trainControl(method = "none")
                        # , metric = "Accuracy"
                        , na.action = na.omit
                        # , preProcess = "medianImpute"
                        # , tuneGrid=expand.grid(parameter=c(0.001, 0.01, 0.1, 1,10,100, 1000))
                        )

# fit_glm <- caret::train(x=train_matrix,
#                         y = target, 
#                         method = "glm", 
#                         family = binomial, 
#                         trControl = my_trControl
#                         # , metric = "Accuracy"
#                         # , na.action = na.omit
#                         # , preProcess = "medianImpute"
#                         # , tuneGrid=expand.grid(parameter=c(0.001, 0.01, 0.1, 1,10,100, 1000))
#                         )

## --------------------------------------------------------------------
## 3b. Fit Random-Forest model
## --------------------------------------------------------------------
set.seed(pi)

fit_rf <- caret::train(target ~ ., 
                       data = ds_train, 
                       method = "rf",
                       trControl = my_trControl,
                       allowParallel = T)







  