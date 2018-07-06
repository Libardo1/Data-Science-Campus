
###############################################################################################################################
## Inspired by: Steven Slezak (http://rstudio-pubs-static.s3.amazonaws.com/171872_ab8dd184af0e4b2cbe3469b2c75b0093.html)
## -- Data source (German credit dataset): https://onlinecourses.science.psu.edu/stat857/node/215/
###############################################################################################################################

## -----------------------------------------------
## Step 0. load library and custom programs
## -----------------------------------------------
source("./03 R programs/load library.R")
source("./03 R programs/plot_histogram_eda.R")

## ---------------------------------------
## Step 1. Import analysis dataset
## ---------------------------------------
## Import original analysis dataset
train_orig <- readr::read_rds(path = "./02 Analysis dataset/train.rds")
test_orig <- readr::read_rds(path = "./02 Analysis dataset/test.rds")

str(train_orig)
str(test_orig)

## Remove id variable
train <- train_orig %>% 
  dplyr::select(-id)

test <- test_orig %>% 
  dplyr::select(-id)

## ------------------------------
## Step 2. Fit ML models
## ------------------------------
## Step 2.1. Split reponse variable from test dataset
creditability_actual <- test %>% 
  dplyr::pull(Creditability)

my_newData <- test %>% 
  dplyr::select(-Creditability)

## Steo 2.3. Define CARET objects
set.seed(pi)

my_trControl <- caret::trainControl(method = "cv", 
                                    number = 10, 
                                    savePredictions = T)  ## "cv" = cross-validation, 10-fold

## Step 2.4. Fit logistic regression model (the CARET package approach)
fit_glm <- caret::train(Creditability ~ ., 
                        data = train, 
                        method = "glm", 
                        family = binomial, 
                        trControl = my_trControl)

## display result
fit_glm

## Evaluate model performance using test dataset
## Result: accuracy = 0.736
creditability_pred_glm <- predict(object = fit_glm, newdata = my_newData)
confMatrix_glm <- confusionMatrix(data = creditability_pred_glm, 
                                  reference = creditability_actual)
confMatrix_glm

## variable importance 
plot(caret::varImp(fit_glm))

## 2.5 Fit Tree regression model
set.seed(pi)

fit_tree <- caret::train(Creditability ~ ., 
                         data = train, 
                         method = "rpart",
                         trControl = my_trControl)
fit_tree

## Evaluate model performance using test dataset
## Result: accuracy = 0.686
creditability_pred_tree <- predict(object = fit_tree, newdata = my_newData)
confMatrix_tree <- confusionMatrix(data = creditability_pred_tree, 
                                   reference = creditability_actual)
confMatrix_tree

## variable importance
plot(caret::varImp(fit_tree))

## plot decision tree
rpart.plot::rpart.plot(x = fit_tree$finalModel)

## --------------------------------------------------------------------
## 3.4 Fit Random-Forest model
## --------------------------------------------------------------------
set.seed(pi)

fit_rf <- caret::train(Creditability ~ ., 
                       data = train, 
                       method = "rf",
                       trControl = my_trControl,
                       allowParallel = T)
fit_rf

## Evaluate model performance using test dataset
## Result: accuracy = 0.734
creditability_pred_rf <- predict(object = fit_rf, newdata = my_newData)
confMatrix_rf <- confusionMatrix(data = creditability_pred_rf, 
                                 reference = creditability_actual)
confMatrix_rf

## variable importance 
plot(caret::varImp(fit_rf))

# ## plot decision tree
# rpart.plot::rpart.plot(x = fit_rf$finalModel)

# randomForest::getTree(rfobj = fit_rf$finalModel)
# plot(as.party(fit_rf$finalModel))

plot(fit_rf)

## --------------------------------------------------------------------
## 3.5 Fit Neural Net model
## --------------------------------------------------------------------
set.seed(pi)

fit_nn <- caret::train(Creditability ~ ., 
                       data = train, 
                       method = "nnet",
                       trControl = my_trControl,
                       allowParallel = T)
fit_nn

## Evaluate model performance using test dataset
## Result: accuracy = 0.728  
creditability_pred_nn <- predict(object = fit_nn, newdata = my_newData)
confMatrix_nn <- confusionMatrix(data = creditability_pred_nn, 
                                 reference = creditability_actual)
confMatrix_nn

plot(fit_nn)

## --------------------------------------------------------------------
## Save final model results
## --------------------------------------------------------------------
readr::write_rds(x = fit_glm$finalModel, path = "./04 Output/final_model_glm.rds")
readr::write_rds(x = fit_tree$finalModel, path = "./04 Output/final_model_tree.rds")
readr::write_rds(x = fit_rf$finalModel, path = "./04 Output/final_model_rf.rds")
readr::write_rds(x = fit_nn$finalModel, path = "./04 Output/final_model_nn.rds")

## --------------------------------------------------------------------
## Compare model performance
## --------------------------------------------------------------------
model_list <- list(glm = fit_glm, rf = fit_rf, nn=fit_nn, tree = fit_tree)
resamples <- resamples(model_list)

# plot the comparison
bwplot(resamples, metric = "Accuracy")






