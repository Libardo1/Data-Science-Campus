
######################
## load library
######################
source("./03 R programs/load library.R")

## Import tweets 
## -- ethiopia
tweet_raw <- readr::read_csv(file = file.choose(), col_names = T)

## Extract websites
# test <- tweet_raw %>% 
#   dplyr::filter(row_number() == c(seq(1,10)))
  
tweet_prep <- tweet_raw %>%
# tweet_prep <- test %>% 
  dplyr::group_by(text) %>% 
  dplyr::mutate(link_raw = paste(as.character(unlist(stringr::str_extract_all(string = text,
                                                                              pattern = "(\\w+)?(https)\\:\\//\\w+\\.\\w+((\\/\\w+)?)"))),
                                 collapse = " ")) %>%
  dplyr::mutate(link = paste(unique(as.character(unlist(stringr::str_split(string = link_raw, 
                                                                           pattern = "\\s+")))), 
                             collapse = " ")) %>%      ## remove duplicates
  dplyr::mutate(user_network_raw = paste(as.character(unlist(stringr::str_extract_all(string = text,
                                                                                      pattern = "\\@\\w+"))),
                                         collapse = " ")) %>%
  dplyr::mutate(user_network = paste(unique(as.character(unlist(stringr::str_split(string = user_network_raw, 
                                                                                   pattern = "\\s+")))), 
                                     collapse = " ")) %>%      ## remove duplicates
  dplyr::mutate(user_hashtag_raw = paste(as.character(unlist(stringr::str_extract_all(string = text,
                                                                                      pattern = "\\#\\w+"))),
                                         collapse = " ")) %>%
  dplyr::mutate(user_hashtag = paste(unique(as.character(unlist(stringr::str_split(string = user_hashtag_raw, 
                                                                                   pattern = "\\s+")))), 
                                     collapse = " ")) %>%       ## remove duplicates
  dplyr::select(-dplyr::contains("_raw")) 


## Save analysis dataset
readr::write_csv(x = tweet_prep, 
                 path = "./02 Analysis dataset/tweets_ethiopia_anal.csv", 
                 col_names = T)




