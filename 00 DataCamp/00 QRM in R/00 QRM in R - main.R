
## load library
library(qrmdata)
library(xts)

###################################################
## Chapter 1: Exploring market risk-factor data
###################################################
## load data
data("SP500")

head(SP500, n = 3)
tail(SP500, n = 3)

## Plot: the 2008 financial crisis
plot(SP500)
