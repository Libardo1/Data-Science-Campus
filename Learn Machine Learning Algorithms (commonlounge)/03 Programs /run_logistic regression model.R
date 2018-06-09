
## -----------------
## load library
## -----------------
source("./03 Programs /load_library.R")

## -----------------------------------------------------
## load raw dataset (Pima Indians Diabetes Database)
## -----------------------------------------------------
pima_diabetes_raw <- readr::read_csv(file = file.choose(), col_names = T)

## ----------------------------
## Step 2: Preprocessing
## ----------------------------
# pima_diabetes <- pima_diabetes_raw %>% 
#   dplyr::mutate(index = row_number())

summary(pima_diabetes)
str(pima_diabetes)

## Derive target variable and convert it into factor
pima_diabetes_prep <- pima_diabetes_raw %>% 
  dplyr::mutate(target = factor(Outcome, levels = c(0, 1), labels = c("No", "Yes"))) %>% 
  dplyr::select(-Outcome)

## conclusion: no missing records
pima_diabetes <- pima_diabetes_prep

## -------------------------------------------------------
## Step 2: Data exploration and visualization
## -------------------------------------------------------

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















