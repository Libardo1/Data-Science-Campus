
## load library
source("./03 R programs/load library.R")

################################
## Import analysis dataset
################################
wholesale_anal <- readr::read_rds(path = "./02 Analysis dataset/wholesale_clustering.rds")

####################################################
## Exploratory data analysis and Visualization
####################################################
GGally::ggpairs(data = wholesale_anal)

## Standardize analysis dataset
wholesale_anal_std <- scale(x = wholesale_anal) %>% 
  as.data.frame()

GGally::ggpairs(data = wholesale_anal_std)

## Visualization for clustering
ggplot(data = wholesale_anal_std, aes(x=Fresh, y=Milk)) + 
  geom_point()


############################
## Clustering analysis
############################
## Calculate distance
dist <- dist(x = wholesale_anal_std)

hc <- hclust(d = dist)
plot(hc)









