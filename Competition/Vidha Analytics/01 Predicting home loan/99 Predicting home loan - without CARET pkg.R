
################################################
## load library and custom functions
################################################
source("./03 R programs/load library.R")

#####################################
## Step 1. Read analysis dataset
#####################################
## Read analysis dataset
train_orig_raw <- readr::read_rds(path = "./02 Analysis dataset/train.rds")
test_orig_raw <- readr::read_rds(path = "./02 Analysis dataset/test.rds")

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
inTrain <- caret::createDataPartition(y = train_orig$target, 
                                      p = 0.75, 
                                      list = F)

## Determine training and test dataset
train <- train_orig[inTrain, ]
test <- train_orig[-inTrain, ]

## Create test dataset without target variable
## - This dataset will be used later to predict target variable and 
##   to calculate confusion matrix
my_newdata <- test %>% 
  dplyr::select(-target)

target_observed <- test %>% 
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

#################################################
## Step 3. Fit Machine learning models
#################################################
## ------------------------------------------
## 3.1 Fit logistic regression model
## ------------------------------------------
# fit_glm <- glm(formula = target ~ ., family = binomial, data = train)
# summary(fit_glm)

set.seed(pi)

fit_glm <- caret::train(target ~ .,
                        data = train,
                        method = "glm",
                        family = binomial
                        , trControl = my_trControl
                        , na.action = na.pass       ## This will pass the NA values unmodified directly to the prediction function (this will cause prediction functions that do not support missing values to fail, for those you would need to specify preProcess to impute the missing values before calling the prediction function). Source: https://stats.stackexchange.com/questions/144922/r-caret-and-nas
                        )

fit_glm          ## Accuracy Test dataset (glm) = 0.802859

plot(caret::varImp(object = fit_glm))

## -----------------------------
## Predict test dataset
## -----------------------------
pred_glm <- predict(object = fit_glm, newdata = my_newdata, 
                    na.action = na.pass)                       ## source: https://stackoverflow.com/questions/24801452/error-in-confusionmatrix-the-data-and-reference-factors-must-have-the-same-numbe

## Accuracy Test dataset (glm) = 0.8051
caret::confusionMatrix(data = pred_glm, reference = target_observed)

