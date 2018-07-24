
################################
## Step 0. load library
################################
source("./03 R programs/load library.R")

##############################################
## Step 1. Import main analysis dataset
##############################################
## Import analysis dataset
data <- readr::read_rds(path = "./02 Analysis dataset/bSharing_day_cnt.rds")

## Check variable type
str(data)

#####################################################################
## Step 2. Fit Machine Learning (ML) models on Bike sharing data
#####################################################################

## ------------------------------------------
## 2.1. Create train / test dataset
## ------------------------------------------
## Create index that goes into the training set
set.seed(pi)

inTrain <- caret::createDataPartition(y = data$cnt, p = 0.75, list = F)

train <- data[inTrain, ]
test <- data[-inTrain, ]

## Remove ID variable
train <- train %>%
  dplyr::select(-id) %>% 
  dplyr::rename(target = cnt)

test <- test %>%
  dplyr::select(-id) %>% 
  dplyr::rename(target = cnt)

## Split target variable from test set
test_features <- test %>%
  dplyr::select(-target)

test_target <- test %>%
  pull(target) %>% 
  as.numeric()

## --------------------------------------------
## Non formula interface for Train function
## --------------------------------------------
# train_features <- train %>%
#   dplyr::select(-target)

## create model matrix
train_x <- model.matrix(target ~ ., -1, data = train)
colnames(train_x)

train_y <- train %>%
  dplyr::pull(target) %>%
  as.matrix()

## --------------------------------
## 2.2. Define custom controls
## --------------------------------
myTrControl <- caret::trainControl(method = 'repeatedcv', 
                                   number = 10, 
                                   repeats = 5)

## --------------------------------
## 2.3a. Fit linear model
## --------------------------------
set.seed(1234)

fit_lm <- caret::train(target ~ .,
                       data = train,
                       method = "lm",
                       trControl = myTrControl)       ## Bug-01: 50: In predict.lm(modelFit, newdata) :
                                                      ## prediction from a rank-deficient fit may be misleading

fit_lm

## Evaluate variable importance
# plot(caret::varImp(object = fit_lm))
plot(caret::varImp(object = fit_lm, scale = T), main = "Variable importance - linear model")

## QQ plot, etc
plot(fit_lm$finalModel)

## Model results
summary(fit_lm)           ## Bug-02:                     Estimate Std. Error t value Pr(>|t|)    
                          ##         workingdayyes       NA         NA      NA       NA 

## ------------------------------------------
## 2.3b. Fit Ridge regression model
## ------------------------------------------
set.seed(1234)   

fit_ridge <- caret::train(target ~ .,
                          data = train,
                          method = "glmnet",
                          tuneGrid = expand.grid(alpha = 0,
                                                 # lambda = seq(0.0001, 1, length = 10)),
                                                 # lambda = seq(0.0001, 0.002, length = 10)),
                                                 lambda = seq(0, 10, length = 10)),
                          trControl = myTrControl) 

fit_ridge

## Explore result
plot(fit_ridge)
plot(fit_ridge$finalModel, xvar = 'lambda', label = T)   
plot(fit_ridge$finalModel, xvar = 'dev', label = T)   

plot(varImp(object = fit_ridge, scale = T))

# summary(fit_ridge$finalModel)

## ------------------------------------------
## 2.3c. Fit Lasso regression model
## ------------------------------------------
set.seed(1234)   

fit_lasso <- caret::train(target ~ .,
                          data = train,
                          method = "glmnet",
                          tuneGrid = expand.grid(alpha = 1,
                                                 # lambda = seq(0.0001, 1, length = 10)),
                                                 # lambda = seq(0.8, 1, length = 10)),
                                                 lambda = seq(0, 10, length = 10)),
                          trControl = myTrControl) 

fit_lasso

## Explore result
plot(fit_lasso)       ## suggests optimal lambda around (0.8, 1), but then (0, 10)
plot(fit_lasso$finalModel, xvar = 'lambda', label = T)   
plot(fit_lasso$finalModel, xvar = 'dev', label = T) 

plot(varImp(object = fit_lasso, scale = T))

## ------------------------------------------
## 2.3d. Fit Elastic Net regression model
## ------------------------------------------
set.seed(1234)   

fit_en <- caret::train(target ~ .,
                       data = train,
                       method = "glmnet",
                       tuneGrid = expand.grid(alpha = seq(0.1, 1, length = 10),
                                              lambda = seq(0.0001, 1, length = 10)),
                                              # lambda = seq(0, 10, length = 10)),
                       trControl = myTrControl)

fit_en

## Explore result
plot(fit_en)       ## suggests optimal lambda around (0.8, 1), but then (0, 10)
plot(fit_en$finalModel, xvar = 'lambda', label = T)   
plot(fit_en$finalModel, xvar = 'dev', label = T) 

plot(varImp(object = fit_en, scale = T))


## -----------------------------------
## Step 2.4. Model comparison
## -----------------------------------
model_list <- list(linear_model = fit_lm,
                   ridge_regression = fit_ridge,
                   lasso_regression = fit_lasso,
                   elastic_net = fit_en)

model_result <- caret::resamples(x = model_list)
summary(model_result)

## Visualize model
bwplot(x = model_result, metric = 'RMSE')
lattice::xyplot(x = model_result, metric = 'RMSE')

## Save model result
readr::write_rds(x = model_result, path = "./04 Output/model_comparison_result - train.rds")
