
###########################################################################################################
## The excercises are obtained from https://www.r-exercises.com/
## Excercise source: https://www.r-exercises.com/2017/06/15/data-manipulation-with-data-table-part-1/
###########################################################################################################

library(tidyverse)

## Ex-1. Load the iris dataset ,make it a data.table and name it iris_dt. 
##       Print mean of Petal.Length, grouping by first letter of Species from iris_dt .
iris_dt <- dplyr::as_data_frame(iris)



