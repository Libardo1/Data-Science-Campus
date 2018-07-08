
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
  dplyr::group_by(screenName, created) %>% 
  dplyr::mutate(link = paste(as.character(unlist(stringr::str_extract_all(string = text,
                                                                          pattern = "(\\w+)?(https)\\:\\//\\w+\\.\\w+((\\/\\w+)?)"))),
                             collapse = " ")) %>%
  dplyr::mutate(user_network = paste(as.character(unlist(stringr::str_extract_all(string = text,
                                                                                  pattern = "\\@\\w+"))),
                                     collapse = " ")) %>%
  dplyr::mutate(user_hashtag = paste(as.character(unlist(stringr::str_extract_all(string = text,
                                                                                  pattern = "\\#\\w+"))),
                                     collapse = " ")) %>%
  dplyr::select(-dplyr::contains("_raw"))


## Save analysis dataset
readr::write_csv(x = tweet_prep, 
                 path = "./02 Analysis dataset/tweets_ethiopia_anal.csv", 
                 col_names = T)




