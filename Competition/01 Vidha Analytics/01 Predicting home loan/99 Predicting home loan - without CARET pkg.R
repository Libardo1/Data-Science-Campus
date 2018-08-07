
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

## ---------------------------
## Imputate missing values
## ---------------------------
train_orig_imputed <- DMwR::knnImputation(data = train_orig)
test_orig_imputed <- DMwR::knnImputation(data = test_orig)

## ----------------------------------------------------------------------------------
## 2b. Create training and test sets from original training dataset (train_orig)
## ----------------------------------------------------------------------------------
## Get index used for data partition
set.seed(pi)
inTrain <- caret::createDataPartition(y = train_orig_imputed$target, 
                                      p = 0.6, 
                                      list = F)

## Determine training and test dataset
train <- train_orig_imputed[inTrain, ]
test <- train_orig_imputed[-inTrain, ]

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
                        # , preProcess = 'medianImpute'
                        # , na.action = na.pass       ## This will pass the NA values unmodified directly to the prediction function (this will cause prediction functions that do not support missing values to fail, for those you would need to specify preProcess to impute the missing values before calling the prediction function). Source: https://stats.stackexchange.com/questions/144922/r-caret-and-nas
                        )

fit_glm          ## Accuracy Test dataset (glm) = 0.7622204

plot(caret::varImp(object = fit_glm))

## -----------------------------
## Predict test dataset
## -----------------------------
pred_glm <- predict(object = fit_glm, newdata = my_newdata
                    # , na.action = na.pass                        ## source: https://stackoverflow.com/questions/24801452/error-in-confusionmatrix-the-data-and-reference-factors-must-have-the-same-numbe
                    )

## Accuracy Test dataset (glm) = 0.75
caret::confusionMatrix(data = pred_glm, reference = target_observed)

# ## ------------------------------------------
# ## 3.2 Fit Naive Bayes classifier
# ## ------------------------------------------
# set.seed(pi)
# 
# fit_nbc <- caret::train(target ~ .,
#                         data = train,
#                         method = "nb"
#                         , trControl = my_trControl
#                         # , na.action = na.pass
#                         )                               ## Failed (see the warning message below)
# 
# # > warnings()
# # Warning messages:
# #   1: In FUN(X[[i]], ...) :
# #   Numerical 0 probability for all classes with observation 8


## ----------------------------------------------------------
## 3.3 Fit CART (Classification and Regression Tree)
## ----------------------------------------------------------
set.seed(pi)

fit_cart <- caret::train(target ~ .,
                         data = train,
                         method = "rpart"
                        , trControl = my_trControl
                        # , na.action = na.pass       
                        )

fit_cart         ## Accuracy Test dataset (cart) = 0.7243377

## -----------------------------
## Predict test dataset
## -----------------------------
pred_cart <- predict(object = fit_cart, newdata = my_newdata
                     # , na.action = na.pass
                     )                       

## Accuracy Test dataset (cart) = 0.6885
caret::confusionMatrix(data = pred_cart, reference = target_observed)

## ----------------------------------------------------------
## 3.4 Fit Random Forest 
## ----------------------------------------------------------
set.seed(pi)

fit_rf <- caret::train(target ~ .,
                       data = train,
                       method = "rf"
                       , trControl = my_trControl
                       # , na.action = na.pass
                       # , na.action = na.omit
                       , allowParallel = T
                       )

fit_rf         ## Accuracy Test dataset (rf) = 0.7595908

## -----------------------------
## Predict test dataset
## -----------------------------
pred_rf <- predict(object = fit_rf, 
                   newdata = my_newdata 
                   # , na.action = na.pass
                   # , na.action = na.omit
                   )

## Accuracy Test dataset (cart) = 0.709
caret::confusionMatrix(data = pred_rf, reference = target_observed)

## ----------------------------------------------------------
## 3.5 Fit Support Vector Machine (SVM) - linear
## ----------------------------------------------------------
set.seed(pi)

fit_svmLinear <- caret::train(target ~ .,
                              data = train,
                              method = "svmLinear"
                              , preProcess = c('center', 'scale')
                              , tuneLength = 10
                              , trControl = my_trControl
                              )

fit_svmLinear         ## Accuracy Test dataset (fit_svmLinear) = 0.7729952

## -----------------------------
## Predict test dataset
## -----------------------------
pred_svmLinear <- predict(object = fit_svmLinear, 
                          newdata = my_newdata 
                          )

## Accuracy Test dataset (fit_svmLinear) = 0.7582
caret::confusionMatrix(data = pred_svmLinear, reference = target_observed)

## ----------------------------------------------------------
## 3.6 Fit Support Vector Machine (SVM) - nonlinear
## ----------------------------------------------------------
set.seed(pi)

fit_svmNonLinear <- caret::train(target ~ .,
                                 data = train,
                                 method = "svmRadial"
                                 , preProcess = c('center', 'scale')
                                 , tuneLength = 10
                                 , trControl = my_trControl
                                 )

fit_svmNonLinear         ## Accuracy Test dataset (fit_svmNonLinear) = 0.7758070

## -----------------------------
## Predict test dataset
## -----------------------------
pred_svmNonLinear <- predict(object = fit_svmNonLinear, 
                             newdata = my_newdata)

## Accuracy Test dataset (pred_svmNonLinear) = 0.75
caret::confusionMatrix(data = pred_svmNonLinear, reference = target_observed)

## ----------------------------------------------------------
## 3.7 Fit Neural Network model
## ----------------------------------------------------------
set.seed(pi)

myGrid <- expand.grid(size = c(4, 5, 6), decay = seq(from = 0.1, to =  0.2, length.out = 4))

fit_nnet <- caret::train(target ~ .,
                         data = train,
                         method = "nnet"
                         # , preProcess = c('center', 'scale')
                         , preProcess = 'range'                  ## Min-Max normalization
                         , tuneGrid = myGrid
                         , iterations = 1000
                         , trControl = my_trControl
                         )

fit_nnet         ## Accuracy Test dataset (fit_nnet) = 0.7566689 

# plot(caret::varImp(object = fit_nnet))

## -----------------------------
## Predict test dataset
## -----------------------------
pred_nnet <- predict(object = fit_nnet, 
                     newdata = my_newdata)

## Accuracy Test dataset (pred_nnet) = 0.7377
caret::confusionMatrix(data = pred_nnet, reference = target_observed)

## plot (source: https://stackoverflow.com/questions/48754886/caret-obtain-train-cv-predictions-from-model-to-plot)
fit_nnet$results %>%
  ggplot()+
  geom_point(aes(x = size, y = Accuracy))+
  geom_smooth(aes(x = size, y = Accuracy))+
  facet_wrap(~decay)

## --------------------------------------------------
## Visualization: Fit the best model using nnet
## --------------------------------------------------
fit_nnet$finalModel     ## a 14-5-1 network with 81 weights

fit_nnet_final <- nnet::nnet(target ~ ., data=train, size = 5, decay = 0.2, maxit = 1000)

plot.nnet(mod.in = fit_nnet_final)     ## plot.nnet -> devtools::source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')



# ## ----------------------------------------------------------
# ## 3.8 Fit Gradient Boosting model
# ## ----------------------------------------------------------
# set.seed(pi)
# 
# ## source: https://datascienceplus.com/extreme-gradient-boosting-with-r/
# train_noTarget <- train %>% 
#   dplyr::select(-target)
# 
# X_train = xgboost::xgb.DMatrix(as.matrix(train_noTarget))
# y_train = train$target
# 
# X_test = xgb.DMatrix(as.matrix(test %>% select(-target)))
# y_test = test$target
# 
# xgbGrid <- expand.grid(nrounds = c(100,200),  # this is n_estimators in the python code above
#                        max_depth = c(10, 15, 20, 25),
#                        colsample_bytree = seq(0.5, 0.9, length.out = 5),
#                        ## The values below are default values in the sklearn-api. 
#                        eta = 0.1,
#                        gamma=0,
#                        min_child_weight = 1,
#                        subsample = 1
#                        )

## STOPPED: 
# > X_train = xgboost::xgb.DMatrix(as.matrix(train_noTarget))
# Error in xgboost::xgb.DMatrix(as.matrix(train_noTarget)) : 
#   'data' has class 'character' and length 4070.
# 'data' accepts either a numeric matrix or a single filename.