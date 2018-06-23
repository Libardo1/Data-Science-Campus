
#############################
## Step 0: load library
#############################
source("./01 R programs/load_library.R")

#######################################################################
## Step 1: Load raw dataset (Pima Indians Diabetes Database)
#######################################################################
pima_diabetes_raw <- readr::read_csv(file = file.choose(), col_names = T)

##################################
## Step 2: Preprocessing
##################################
# pima_diabetes <- pima_diabetes_raw %>% 
#   dplyr::mutate(index = row_number())

summary(pima_diabetes_raw)
str(pima_diabetes_raw)

## Derive target variable and convert it into factor
pima_diabetes_prep <- pima_diabetes_raw %>% 
  dplyr::mutate(target = factor(Outcome, levels = c(0, 1), 
                                labels = c("No", "Yes"))) %>% 
  dplyr::select(-Outcome)

## conclusion: no missing records
pima_diabetes <- pima_diabetes_prep

###########################################################
## Step 2: Data exploration and visualization
###########################################################

## scatter plot
ggplot2::ggplot(data = pima_diabetes, 
                aes(x = Glucose, y = Insulin, group = target)) +
  geom_point(aes(x = Glucose, y = Insulin, group = target, color = target))

## box plot
ggplot2::ggplot(data = pima_diabetes, 
                aes(x = target, y = Glucose)) + 
  geom_boxplot(fill = c("green", "red"))+
  scale_y_continuous("Glucose level")+
  labs(title = "Glucose level distribution", x = "Diabetes diagnosis")

#############################################################
## Step 3: Fit machine learning models
#############################################################
## ---------------------------------------
## 3.0 Create training and test sets
## ---------------------------------------
train <- caret::createDataPartition(y = pima_diabetes$target, p = 0.8, list = F)

## get training set
ds_train <- pima_diabetes[train, ]

## get test set
ds_test <- pima_diabetes[-train, ]

## partition target and features of test dataset for latter use
my_newdata <- ds_test %>% 
  dplyr::select(-target)
diabetes_observed <- ds_test %>% 
  dplyr::pull(target)

## ---------------------------------------
## 3.1 Define the train control object
## ---------------------------------------
my_trControl <- caret::trainControl(method = "cv", number = 10, 
                                    savePredictions = T)  ## "cv" = cross-validation, 10-fold

## --------------------------------------------------------------------
## 3.2 Fit logistic regression model (the CARET package approach)
## --------------------------------------------------------------------
set.seed(pi)

fit_glm <- caret::train(target ~ ., 
                        data = ds_train, 
                        method = "glm", 
                        family = binomial, 
                        trControl = my_trControl)

## display result
fit_glm

## Evaluate model performance using test dataset
## Result: accuracy = 0.732
diabetes_predicted_glm <- predict(object = fit_glm, newdata = my_newdata)
confMatrix_glm <- confusionMatrix(data = diabetes_predicted_glm, 
                                  reference = diabetes_observed)
confMatrix_glm

## variable importance 
plot(caret::varImp(fit_glm))

## --------------------------------------------------------------------
## 3.3 Fit Tree regression model
## --------------------------------------------------------------------
set.seed(pi)

fit_tree <- caret::train(target ~ ., 
                         data = ds_train, 
                         method = "rpart",
                         trControl = my_trControl)
fit_tree

## Evaluate model performance using test dataset
## Result: accuracy = 0.6863 
diabetes_predicted_rpart <- predict(object = fit_tree, newdata = my_newdata)
confMatrix_tree <- confusionMatrix(data = diabetes_predicted_rpart, 
                                   reference = diabetes_observed)
confMatrix_tree

## variable importance 
plot(caret::varImp(fit_tree))

## plot decision tree
rpart.plot::rpart.plot(x = fit_tree$finalModel)

## --------------------------------------------------------------------
## 3.4 Fit Random-Forest model
## --------------------------------------------------------------------
set.seed(pi)

fit_rf <- caret::train(target ~ ., 
                       data = ds_train, 
                       method = "rf",
                       trControl = my_trControl,
                       allowParallel = T)
fit_rf

## Evaluate model performance using test dataset
## Result: accuracy = 0.7255
diabetes_predicted_rf <- predict(object = fit_rf, newdata = my_newdata)
confMatrix_rf <- confusionMatrix(data = diabetes_predicted_rf, 
                                   reference = diabetes_observed)
confMatrix_rf

## variable importance 
plot(caret::varImp(fit_rf))






