

## load library
source("./03 R programs/load library.R")
source("./03 R programs/plot_association_cat.R")
source("./03 R programs/plot_association_interval.R")

## load dataset
train <- readr::read_csv(file = file.choose(), col_names = T)
test <- readr::read_csv(file = file.choose(), col_names = T)

## Define ID variable
id_var <- "Loan_ID"

##################################
## Exploratory data analysis
##################################
summary(train)

## ---------------------------------------------------------------------------
## The boxplot suggests that we should remove outliers before predictions
## ---------------------------------------------------------------------------
train$outlier_ApplicantIncome <- outliers::scores(x = train$ApplicantIncome, 
                                                  type = "chisq", 
                                                  prob = 0.9)

## ----------------------------------------
## Barplot for categorical variables
## ----------------------------------------
plot_association_cat(dsin = train, response_var = "Loan_Status", id_var = "Loan_ID")

## ------------------------------------
## Boxplot for numeric variables
## ------------------------------------
# ggplot(data = train, aes(x = Loan_Status, y = ApplicantIncome)) + 
#   geom_boxplot()

plot_association_interval()




  