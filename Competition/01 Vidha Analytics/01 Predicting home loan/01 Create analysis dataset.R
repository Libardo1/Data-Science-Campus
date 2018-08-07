
## load library and custom functions
source("./03 R programs/load library.R")

source("03 R programs/get_varMetadata.R")
source("./03 R programs/plot_association_eda.R")
source("./03 R programs/plot_histogram_eda.R")

## load dataset
train_raw <- readr::read_csv(file = "./01 Raw dataset/train_u6lujuX_CVtuZ9i.csv", 
                             col_names = T)
test_raw <- readr::read_csv(file = "./01 Raw dataset/test_Y3wMUE5_7gLdaTN.csv", 
                            col_names = T)

#########################################################
## Preprocessing 1.
## ------------------------------------------------------
## Change variable type, from character to factor
#########################################################
# train <- train_raw %>% 
#   dplyr::mutate(Loan_Status = factor(Loan_Status))

train_prep1 <- train_raw %>% 
  dplyr::mutate_if(is.character, as.factor)

test_prep1 <- test_raw %>% 
  dplyr::mutate_if(is.character, as.factor)

#############################################################
## Preprocessing 2.
## ----------------------------------------------------------
## Visualization and EDA for detecting outliers and 
## possible transformation and recoding
#############################################################

## Exploratory data analysis
## Finding-01: Min=0 for some variables (e.g., ApplicantIncome, CoapplicantIncome)
summary(train_prep1)
summary(test_prep1)

## -----------------
## Histogram
## -----------------
## Get variable metadata for training set
metadata_variable_train <- get_varMetadata(dsin = train_prep1, 
                                           id_var = "Loan_ID", 
                                           is_train = T)

# ## Save metadata
# readr::write_csv(x = metadata_variable_train, 
#                  path = "./04 Output/metadata_variable_train.csv", 
#                  col_names = T)

# plot_histogram_eda(dsin = train_prep1, 
#                    metadata_variable = metadata_variable_train, 
#                    id_var = "Loan_ID")

# ## -------------------------------------
# ## Barplot for categorical variables
# ## -------------------------------------
# plot_association_eda(dsin = train_prep1, 
#                      response_var = "Loan_Status", 
#                      plot_type = "barplot", 
#                      id_var = "Loan_ID")

## ---------------------------------
## Boxplot for numeric variables
## ---------------------------------
# ggplot(data = train_prep1, aes(x = Loan_Status, y = ApplicantIncome)) +
#   geom_boxplot()

# plot_association_eda(dsin = train_prep1, 
#                      response_var = "Loan_Status", 
#                      plot_type = "boxplot", 
#                      id_var = "Loan_ID")

## ---------------------------------------------------
## Action 2a. 
## ---------------------------------------------------
## - Convert Credit_History variable into factor.
## - Recode Loan_Amount_Term from months to years,  
##   and then convert it into factor.
## ---------------------------------------------------
## train dataset
train_prep2 <- train_prep1 %>% 
  dplyr::mutate(Credit_History = factor(Credit_History)) 
# %>% 
#   dplyr::mutate(Loan_Amount_Term_raw = Loan_Amount_Term) %>% 
#   dplyr::mutate(Loan_Amount_Term = factor(cut(Loan_Amount_Term_raw, 
#                                               breaks = c(-Inf, 12,36,60,84,120,180, 
#                                                          240,300,360,480),
#                                               labels = c("1",   "2", "3", "4", "5", 
#                                                          "6",  "7",  "8", "9", "10")))) %>%    ## "if breaks is a vector, then labels must be a vector with length one less than breaks" (source: https://stackoverflow.com/questions/13061738/cut-and-labels-breaks-length-conflict)
#   dplyr::select(-contains("_raw"))       ## Finding-02: This kind of recoding creates rank-deficient problem

## test dataset
test_prep2 <- test_prep1 %>% 
  dplyr::mutate(Credit_History = factor(Credit_History)) 
# %>% 
#   dplyr::mutate(Loan_Amount_Term_raw = Loan_Amount_Term) %>% 
#   dplyr::mutate(Loan_Amount_Term = factor(cut(Loan_Amount_Term_raw, 
#                                               breaks = c(-Inf, 12,36,60,84,120,180, 
#                                                          240,300,360,480),
#                                               labels = c("1",   "2", "3", "4", "5", 
#                                                          "6",  "7",  "8", "9", "10")))) %>%    ## "if breaks is a vector, then labels must be a vector with length one less than breaks" (source: https://stackoverflow.com/questions/13061738/cut-and-labels-breaks-length-conflict)
#   dplyr::select(-contains("_raw"))      ## Finding-02: This kind of recoding creates rank-deficient problem

# ## Boxplot for numeric variables
# ## -- check for possible trainsformation for ff variables:
# ##    - ApplicantIncome, CoapplicantIncome and LoanAmount
# plot_association_eda(dsin = train_prep2, 
#                      response_var = "Loan_Status", 
#                      plot_type = "boxplot", 
#                      id_var = "Loan_ID")

## ----------------------------------------------------
## Apply transformation for the above 3 variables
## ----------------------------------------------------
## train dataset
train_prep3 <- train_prep2 %>% 
  dplyr::rename(ApplicantIncome_raw = ApplicantIncome) %>% 
  dplyr::rename(CoapplicantIncome_raw = CoapplicantIncome) %>% 
  dplyr::rename(LoanAmount_raw = LoanAmount) %>% 
  dplyr::mutate(ln_ApplicantIncome = log(ApplicantIncome_raw + 1)) %>%       ## solution for Finding-01 
  dplyr::mutate(ln_CoapplicantIncome = log(CoapplicantIncome_raw + 1)) %>%   ## solution for Finding-01 
  dplyr::mutate(ln_LoanAmount = log(LoanAmount_raw))

## test dataset
test_prep3 <- test_prep2 %>% 
  dplyr::rename(ApplicantIncome_raw = ApplicantIncome) %>% 
  dplyr::rename(CoapplicantIncome_raw = CoapplicantIncome) %>% 
  dplyr::rename(LoanAmount_raw = LoanAmount) %>% 
  dplyr::mutate(ln_ApplicantIncome = log(ApplicantIncome_raw + 1)) %>%       ## solution for Finding-01  
  dplyr::mutate(ln_CoapplicantIncome = log(CoapplicantIncome_raw + 1)) %>%   ## solution for Finding-01  
  dplyr::mutate(ln_LoanAmount = log(LoanAmount_raw))


# ## Boxplot for numeric variables
# plot_association_eda(dsin = train_prep3, 
#                      response_var = "Loan_Status", 
#                      plot_type = "boxplot", 
#                      id_var = "Loan_ID")

## ------------------------
## Drop raw variables
## ------------------------
## train dataset
train_prep3 <- train_prep3 %>% 
  dplyr::select(-contains("_raw"))

## test dataset
test_prep3 <- test_prep3 %>% 
  dplyr::select(-contains("_raw"))

# ## Summarize
# summary(train_prep3)
# summary(test_prep3)

## Recode response variable to integer (0, 1)
train_prep4 <- train_prep3 %>% 
  dplyr::rename(Loan_Status_raw = Loan_Status) %>% 
  dplyr::mutate(Loan_Status = factor(ifelse(Loan_Status_raw == 'Y', 1, 0))) %>% 
  dplyr::select(-contains('_raw')) %>% 
  as.data.frame()

test_prep4 <- test_prep3 %>%     ## No target variable in TEST dataset
  as.data.frame()

# ## Summary
# summary(train_prep4)

## Add rowname
rownames(train_prep4) <- train_prep4$Loan_ID
rownames(test_prep4) <- test_prep4$Loan_ID

########################################
## Create final analysis dataset
########################################
train <- train_prep4
test <- test_prep4

## Save final analysis dataset
# readr::write_csv(x = train, path = "./02 Analysis dataset/train.csv")
# readr::write_csv(x = test,  path = "./02 Analysis dataset/test.csv")

readr::write_rds(x = train, path = "./02 Analysis dataset/train.rds")
readr::write_rds(x = test, path = "./02 Analysis dataset/test.rds")




