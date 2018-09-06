
## load library
source("./03 R programs/load library.R")

## import raw dataset
data_raw <- readr::read_csv(file = "./01 Raw dataset/malaria-mosquito/Africa_Vectors_database_1898-2016.csv", col_names = T)
