

## load library
source("./03 R programs/load library.R")

## load dataset
train <- readr::read_csv(file = file.choose(), col_names = T)
test <- readr::read_csv(file = file.choose(), col_names = T)

## exploratory data analysis
summary(train)
ggplot(data = train, aes(x = Loan_Status, y = ApplicantIncome)) + 
  geom_boxplot()

## The boxplot suggests that we should remove outliers before predictions
train$outlier_ApplicantIncome <- outliers::scores(x = train$ApplicantIncome, type = "chisq", prob = 0.9)
  