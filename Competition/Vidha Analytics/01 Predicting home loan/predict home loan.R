

## load library
source("./03 R programs/load library.R")
source("./03 R programs/plot_association_eda.R")

## load dataset
train_raw <- readr::read_csv(file = file.choose(), col_names = T)
test_raw <- readr::read_csv(file = file.choose(), col_names = T)

## Change variable type, from character to factor
# train <- train_raw %>% 
#   dplyr::mutate(Loan_Status = factor(Loan_Status))

train <- train_raw %>% 
  dplyr::mutate_if(is.character, as.factor)

test <- test_raw %>% 
  dplyr::mutate_if(is.character, as.factor)

## Define ID variable
id_var <- "Loan_ID"

##################################
## Exploratory data analysis
##################################
summary(train)
summary(test)

## ----------------------------------------
## Barplot for categorical variables
## ----------------------------------------
plot_association_eda(dsin = train, 
                     response_var = "Loan_Status", 
                     plot_type = "barplot", 
                     id_var = "Loan_ID")

## ------------------------------------
## Boxplot for numeric variables
## ------------------------------------
# ggplot(data = train, aes(x = Loan_Status, y = ApplicantIncome)) +
#   geom_boxplot()

plot_association_eda(dsin = train, 
                     response_var = "Loan_Status", 
                     plot_type = "boxplot", 
                     id_var = "Loan_ID")

## ---------------------------------------------------------------------------
## The boxplot suggests that we should remove outliers before predictions
## ---------------------------------------------------------------------------
train$outlier_ApplicantIncome <- outliers::scores(x = train$ApplicantIncome, 
                                                  type = "chisq", 
                                                  prob = 0.9)




  