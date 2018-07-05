
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
## Result: accuracy = 0.746
creditability_pred_glm <- predict(object = fit_glm, newdata = my_newData)
confMatrix_glm <- confusionMatrix(data = creditRisk_pred_glm, 
                                  reference = creditability_actual)
confMatrix_glm

## variable importance 
plot(caret::varImp(fit_glm))

