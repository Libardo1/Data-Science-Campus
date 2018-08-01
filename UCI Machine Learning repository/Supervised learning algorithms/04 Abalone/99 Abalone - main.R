
#################################################################################
## Given is the attribute name, attribute type, the measurement unit and a
## brief description.  The number of rings is the value to predict: either
## as a continuous value or as a classification problem.
#################################################################################

#############################
## Step 0 . load library
#############################
source("./03 R programs/load library.R")

########################################
## Step 1. Import analysis dataset
########################################
abolane_anal <- readr::read_rds(path = "./02 Analysis dataset/abalone.rds")

# ## Multiple scatter plots
# GGally::ggpairs(data = abolane_anal)

#####################################################
## Step 2. Split dataset into training and test
#####################################################
set.seed(123)

inTrain <- sample(x = 2, size = nrow(abolane_anal), 
                  replace = T, prob = c(0.70, 0.30))    ## 70% in Train and 30% in Test dataset

train <- abolane_anal[inTrain == 1, ]
test <- abolane_anal[inTrain == 2, ]

## Split features (or independent variables / predictors) and  
## target (or dependent / response variable) for test dataset
test_feature <- test %>%      ## created to perform prediction using PREDICT function
  dplyr::select(-Rings)

test_target <- test %>%      ## created to evaluate model performance using RMSE measure
  dplyr::pull(Rings) %>%
  as.numeric()

##############################################
## Step 3. Fit Machine Learning models
##############################################
## ------------------------------------------
## Step 3.1. Fit linear regression model
## ------------------------------------------
## Fit model
fit_lm <- glm(Rings ~ ., family = gaussian, data = train)
fit_lm

summary(fit_lm)

## Predict Abalone age / rings
pred_lm <- predict(object = fit_lm, newdata = test_feature)
head(pred_lm)

## Evaluate model performance
## -- RMSE = 2.223984
# Metrics::mse(actual = test_target, predicted = pred_lm)
rmse_lm <- Metrics::rmse(actual = test_target, predicted = pred_lm)
rmse_lm

## ------------------------------------------------------------------
## Step 3.2. Fit Tree regression / Decision tree / CART 
## ------------------------------------------------------------------
## Fit CART model
fit_rp <- rpart::rpart(Rings ~ ., data = train, method = 'anova')

fit_rp

## Visialize CART result
rpart.plot::rpart.plot(x = fit_rp, type = 3, fallen.leaves = T)

## Predict Abalone age / rings
pred_rp <- predict(object = fit_rp, newdata = test_feature)
head(pred_rp)

## Evaluate model performance
## -- RMSE = 2.454184
rmse_rp <- Metrics::rmse(actual = test_target, predicted = pred_rp)
rmse_rp

## ------------------------------------------
## Step 3.3. Fit random forest model
## ------------------------------------------
set.seed(pi)

fit_rf <- randomForest::randomForest(Rings ~ ., data = train, 
                                     importance = TRUE, ntree = 2000)

fit_rf

## Plot variable importance
randomForest::varImpPlot(x = fit_rf)
rpart.plot::rpart.plot(x = fit_rp, type = 3, fallen.leaves = T)

## Predict Abalone age / rings
pred_rf <- predict(object = fit_rf, newdata = test_feature)
head(pred_rf)

## Evaluate model performance
## -- RMSE = 2.200825
rmse_rf <- Metrics::rmse(actual = test_target, predicted = pred_rf)
rmse_rf

## ------------------------------------------
## Step 3.3. Fit ridge regression
## ------------------------------------------
train_x <- model.matrix(Rings ~ ., data = train)[,-1]
train_x <- as.matrix(train_x)

train_y <- as.matrix(train[,9])

fit_ridge <- glmnet::glmnet(x = train_x, y = train_y, family = 'gaussian' , alpha = 0)
fit_ridge

summary(fit_ridge)

## Predict Abalone age / rings
test_x <- model.matrix(~ ., data = test_feature)[,-1]
test_x <- as.matrix(test_x)

pred_ridge <- predict(object = fit_ridge, newx = test_x)
str(pred_ridge)
class(pred_ridge)

head(pred_ridge)

pred_ridge <- as.numeric(pred_ridge)

## Evaluate model performance
## -- RMSE = 2.853409
rmse_ridge <- Metrics::rmse(actual = test_target, predicted = pred_ridge)
rmse_ridge

## ----------------------------------------------------------------------------------------------
## Search for best lambda
## -- source: https://stackoverflow.com/questions/35437411/error-in-predict-glmnet-function-in-r
## ----------------------------------------------------------------------------------------------
set.seed(2*pi)

k <- 5
grid <- 10^seq(10,-2, length =100)
# grid <- 10^seq(10,-10, length =100)
# grid <- 10^seq(10,-1, length =100)
fit_ridge_lambda <- glmnet::cv.glmnet(x = train_x, y = train_y, family = 'gaussian' , alpha = 0,
                                      k=k, lambda = grid)
lambda_min <- fit_ridge_lambda$lambda.min
lambda_min

plot(fit_ridge_lambda)

## Evaluate model performance again
pred_ridge2 <- predict(object = fit_ridge_lambda, newx = test_x, 
                       s = lambda_min)

## -- RMSE = 2.218021
rmse_ridge2 <- Metrics::rmse(actual = test_target, predicted = pred_ridge2)
rmse_ridge2

## ------------------------------------------
## Step 3.4. Fit lasso regression
## ------------------------------------------
set.seed(2*pi)

fit_lasso <- glmnet::cv.glmnet(x = train_x, y = train_y, family = 'gaussian' , alpha = 1,
                               k=k, lambda = grid)
lambda_min <- fit_lasso$lambda.min
lambda_min

plot(fit_lasso)
abline(v = lambda_min, col='green')

## Evaluate model performance again
pred_lasso <- predict(object = fit_lasso, newx = test_x, 
                      s = lambda_min)

## -- RMSE = 2.216356
rmse_lasso <- Metrics::rmse(actual = test_target, predicted = pred_lasso)
rmse_lasso

# ## Variable importance
# importance(fit_lasso)




