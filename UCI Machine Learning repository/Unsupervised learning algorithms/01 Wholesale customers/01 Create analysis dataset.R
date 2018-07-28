
## load library
source("./03 R programs/load library.R")

## Import data
wholesale_raw <- readr::read_csv(file = file.choose(), col_names = T)

## Recode channel and region
wholesale_prep1 <- wholesale_raw %>% 
  dplyr::rename(Channel_raw = Channel) %>% 
  dplyr::mutate(Channel = factor(Channel_raw, levels = c(1,2), 
                                 labels = c('Horeca', 'Retail'))) %>% 
  dplyr::rename(Region_raw = Region) %>% 
  dplyr::mutate(Region = factor(Region_raw, levels = c(1,2,3), 
                                labels = c('Lisbon', 'Oporto', 'Other'))) %>% 
  dplyr::select(-contains('_raw')) %>% 
  dplyr::mutate(id = row_number()) %>% 
  dplyr::mutate(row_nbr = paste(id, Region, Channel, sep = "_"))

###########################################
## Objective 1. Clustering analysis
###########################################
## Get predictors for clustering
wholesale_clustering <- wholesale_prep1 %>% 
  dplyr::select(-c(Channel, Region, id, row_nbr)) %>% 
  as.data.frame()

## Modify rownames for latter usage
rownames(wholesale_clustering) <- wholesale_prep1$row_nbr

## Save analysis dataset
readr::write_rds(x = wholesale_clustering, path = "./02 Analysis dataset/wholesale_clustering.rds")

