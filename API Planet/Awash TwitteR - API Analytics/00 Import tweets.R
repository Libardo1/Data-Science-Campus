
######################################################################################################################################
## Inspired by:
## -------------
## 1. toddmotto (https://github.com/toddmotto/public-apis)
## 2. Michael Galarnyk (https://medium.com/@GalarnykMichael/accessing-data-from-twitter-api-using-r-part1-b387a1c7d3e)
######################################################################################################################################

######################
## load library
######################
source("./03 R programs/load library.R")
#########################
## Setup Twitter API
#########################
api_twitter <- readxl::read_excel(path = file.choose(), sheet = "Twitter")

consumer_key <- api_twitter$consumer_key
consumer_secret <- api_twitter$consumer_secret
access_token <- api_twitter$access_token
access_secret <- api_twitter$access_secret

twitteR::setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#########################################
## Analysing Dr. Abiy (Ethiopia PM)
#########################################
## Define input parameters
date_week <- as.character(lubridate::today() - 7)
topic_twitter <- '#ethiopia'

tw <- twitteR::searchTwitter(topic_twitter,
                             # n = 1e4, 
                             since = date_week, 
                             retryOnRateLimit = 1e3)
d <- twitteR::twListToDF(tw)

# ## Save raw dataset
# readr::write_csv(x = d,
#                  path = "./01 Raw dataset/hashTag_abiyahmed_20180101_20180707.csv",
#                  col_names = T)