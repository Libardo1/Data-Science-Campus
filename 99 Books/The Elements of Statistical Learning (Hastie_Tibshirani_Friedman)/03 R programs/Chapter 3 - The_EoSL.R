
####################################################
## Chapter 3: Linear Methods for Regression
####################################################

## ---------------------
## load library
## ---------------------
source("./03 R programs/load library.R")

## --------------------------
## Load Prostate dataset
## --------------------------
data("Prostate", package = "lasso2")
attach(Prostate)

## ----------------------
## Exploratory dataset
## ----------------------
summary(Prostate)

## corrlation matrix
cor(Prostate)

ggiraphExtra::ggCor(data = Prostate, label = 2, interactive = T)


