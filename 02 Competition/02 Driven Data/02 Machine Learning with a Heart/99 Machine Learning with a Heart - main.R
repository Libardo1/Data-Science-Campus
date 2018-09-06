
###############################
## Step 0. load library
###############################
source("./04 R programs/load library.R")

########################################
## Step 1. Import analysis dataset
########################################
train_orig <- readr::read_rds(path = "./03 Analysis dataset/train_anal.rds")
test_orig <- readr::read_rds(path = "./03 Analysis dataset/test_anal.rds")

#####################################
## Step 2. EDA and missing data
#####################################
## EDA
summary(train_orig)

## --------------------------
## Identify missing values
## --------------------------
train_orig %>% 
  dplyr::filter(!complete.cases(.))        ## no missing records

## test dataset
test_orig %>% 
  dplyr::filter(!complete.cases(.))        ## no missing records


##########################################
## Step 3. Modeling - Machine learning
##########################################
## ---------------------------
## 3.1. Data preparation
## ---------------------------
## Data partition
set.seed(pi)

inTrain <- caret::createDataPartition(y = train_orig$heart_disease_present, 
                                      p = 0.7, list = F)

train <- train_orig[inTrain, ]
test <- train_orig[-inTrain, ]

## Check distribution of response variable in train vs test dataset
table(train$heart_disease_present)
table(test$heart_disease_present)

## Split test dataset into features and target
test_feature <- test %>%
  dplyr::select(-heart_disease_present)

test_target <- test %>%
  dplyr::pull(heart_disease_present)

## ------------------------------------------
## 3.2. Define cross-validation design
## ------------------------------------------
cv_design <- caret::trainControl(method = 'repeatedcv',
                                 number = 10,
                                 repeats = 5)

## ------------------------
## 3.3. Fit ML models
## ------------------------

## ******************************************
## 3.3a. Simple logistic regression model
## ******************************************
## Fit logistic model
set.seed(2*pi)

fit_glm <- caret::train(heart_disease_present ~ ., 
                        data = train,
                        method = 'glm',
                        family = 'binomial',
                        trControl = cv_design
                        )

## Bug-01: 
## - Fix: This warning can be ignored (source: https://stackoverflow.com/questions/26558631/predict-lm-in-a-loop-warning-prediction-from-a-rank-deficient-fit-may-be-mis)
# Warning messages:
#   1: In predict.lm(object, newdata, se.fit, scale = 1, type = ifelse(type ==  :
#                                                                        prediction from a rank-deficient fit may be misleading

## Explore variable importance 
plot(caret::varImp(fit_glm))

## Prediction
pred_glm <- predict(object = fit_glm, newdata = test_feature)

## Evaluate model performance using confusion matrix
confMat_glm <- caret::confusionMatrix(data = pred_glm, 
                                      reference = test_target)
confMat_glm$overall[1]    ## Accuracy: 0.7592593 

## ******************************************
## 3.3b. Random-Forest model
## ******************************************
## Fit random-forest model
set.seed(2*pi)

fit_rf <- caret::train(heart_disease_present ~ ., 
                       data = train,
                       method = 'rf',
                       trControl = cv_design,
                       allowParallel = T
                       )
fit_rf

## Explore variable importance
plot(caret::varImp(fit_rf))

## Prediction
pred_rf <- predict(object = fit_rf, newdata = test_feature)

## Evaluate model performance using confusion matrix
confMat_rf <- caret::confusionMatrix(data = pred_rf, 
                                     reference = test_target)
confMat_rf$overall[1]    ## Accuracy: 0.7777778 

# ## ****************************************************************************************
# ## 3.3b-ii. Random-Forest model with Random search
# ## - source: https://machinelearningmastery.com/tune-machine-learning-algorithms-in-r/
# ## ****************************************************************************************
# ## Fit random-forest model
# cv_design_mdf <- cv_design <- caret::trainControl(method = 'repeatedcv',
#                                                   number = 10,
#                                                   repeats = 5,
#                                                   search = 'random')
# set.seed(2*pi)
# mtry <- sqrt(ncol(train))
# 
# fit_rf_randomSearch <- caret::train(heart_disease_present ~ ., 
#                                     data = train,
#                                     method = 'rf',
#                                     trControl = cv_design_mdf,
#                                     allowParallel = T
#                                     , tuneLength = 15
#                                     )
# fit_rf_randomSearch
# plot(fit_rf_randomSearch)

# ## ****************************************************************************************
# ## 3.3b-iii. Random-Forest model with Grid search
# ## - source: https://machinelearningmastery.com/tune-machine-learning-algorithms-in-r/
# ## ****************************************************************************************
# ## Fit random-forest model
# cv_design_mdf2 <- cv_design <- caret::trainControl(method = 'repeatedcv',
#                                                    number = 10,
#                                                    repeats = 5,
#                                                    search = 'grid')
# set.seed(2*pi)
# tunegrid <- expand.grid(.mtry=c(1:15))
# 
# fit_rf_gridSearch <- caret::train(heart_disease_present ~ ., 
#                                   data = train,
#                                   method = 'rf',
#                                   trControl = cv_design_mdf2,
#                                   allowParallel = T
#                                   , tuneGrid = tunegrid
#                                   )
# fit_rf_gridSearch
# plot(fit_rf_gridSearch)

## -------------------------------------------------------------------------------------
## Conclusion - rf: mtry=2 is the best value. The same value can be obtained without 
## even random or grid search
## -------------------------------------------------------------------------------------



## ******************************************
## 3.3b. Neural Net model
## ******************************************
## Fit neural net model
set.seed(2*pi)

fit_nn <- caret::train(heart_disease_present ~ ., 
                       data = train,
                       method = 'nnet',
                       trControl = cv_design,
                       allowParallel = T
                       , verbose = F
                       )
fit_nn

## Explore variable importance
plot(caret::varImp(fit_nn))

## Prediction
pred_nn <- predict(object = fit_nn, newdata = test_feature)

## Evaluate model performance using confusion matrix
confMat_nn <- caret::confusionMatrix(data = pred_nn, 
                                     reference = test_target)
confMat_nn$overall[1]    ## Accuracy: 0.7222222 

## ********************************************************************************************
## 3.3b-ii. Neural Net model with grid search
## - source: https://stackoverflow.com/questions/42417948/how-to-use-size-and-decay-in-nnet
## ********************************************************************************************
## Fit neural net model with grid search
set.seed(2*pi)
nnetGrid <-  expand.grid(size = seq(from = 1, to = 10, by = 1),
                         decay = seq(from = 0.1, to = 0.5, by = 0.1))


fit_nn_gridSearch <- caret::train(heart_disease_present ~ ., 
                                  data = train,
                                  method = 'nnet',
                                  trControl = cv_design,
                                  allowParallel = T
                                  , verbose = F
                                  , tuneGrid = nnetGrid
                                  )
fit_nn_gridSearch

plot(fit_nn_gridSearch)

## Prediction
pred_nn_gridSearch <- predict(object = fit_nn_gridSearch, newdata = test_feature)

## Evaluate model performance using confusion matrix
confMat_nn_gridSearch <- caret::confusionMatrix(data = pred_nn_gridSearch, 
                                                reference = test_target)
confMat_nn_gridSearch$overall[1]    ## Accuracy: 0.7222222 

## --------------------------------------------------------------------
## Save final model results
## --------------------------------------------------------------------
readr::write_rds(x = fit_glm$finalModel, path = "./05 Output/final_model_glm.rds")
readr::write_rds(x = fit_rf$finalModel, path = "./05 Output/final_model_rf.rds")
readr::write_rds(x = fit_nn_gridSearch$finalModel, path = "./05 Output/final_model_nn.rds")

## --------------------------------------------------------------------
## Compare model performance
## --------------------------------------------------------------------
model_list <- list(glm = fit_glm, rf = fit_rf, nn=fit_nn_gridSearch)
resamples <- caret::resamples(x = model_list)

# plot the comparison
bwplot(resamples, metric = "Accuracy")


####################################
## Step 4. Perform submission
####################################
## Final model
fit_rf$finalModel

## Prediction
pred_submission <- predict(object = fit_rf, newdata = test_orig)

df_submission <- as.data.frame(cbind(test_orig, pred_submission)) %>% 
  dplyr::mutate(heart_disease_present = as.numeric(as.character(pred_submission))) %>%
  # dplyr::select(heart_disease_present) %>% 
  dplyr::mutate(patient_id = rownames(test_orig)) %>% 
  dplyr::select(patient_id, heart_disease_present)

## Save submission
filename_out <- file.path(paste("./05 Output/submission_heart4DD_awashAnalytics/submission_heart4DD_awashAnalytics_", 
                                lubridate::today(), '.csv', sep = ''))
readr::write_csv(x = format(df_submission, nsmall=2), path = filename_out, col_names = T)







