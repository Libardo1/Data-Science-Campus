
## load library
source("./03 R programs/load library.R")

#################################################
## Step 1. Setup YouTube API connection
#################################################
## ------------------------------------
## Import YouTube API credentials
## ------------------------------------
# credential_yt <- rjson::fromJSON(json_str = file.choose())       ## failed...
credential_yt <- jsonlite::fromJSON(txt = file.choose(), simplifyDataFrame = T)
# credential_yt <- jsonlite::stream_in(file(file.choose()))

credential_yt_df <- credential_yt[[1]] %>% 
  dplyr::as_data_frame() %>% 
  dplyr::distinct(client_id, client_secret)

client_id <- credential_yt_df$client_id
client_secret <- credential_yt_df$client_secret

## -----------------------------------
## Connect to YouTube via API
## -----------------------------------
tuber::yt_oauth(app_id = client_id, app_secret = client_secret)

##########################################
## Step 2. Get access to YouTube data
##########################################
## ----------------------------------
## Get YouTube data by topic
## ----------------------------------
about_ethiopia <- tuber::yt_search(term = "ethiopia", max_results = 50, type = 'video')
about_drAbiyAhmed <- tuber::yt_search(term = "abiy", max_results = 50, type = 'video')
about_lalibela <- tuber::yt_search(term = "lalibela", max_results = 50, type = 'video')

## Save raw dataset
readr::write_csv(x = about_ethiopia, path = "./01 Raw dataset/about_ethiopia.csv")
readr::write_csv(x = about_drAbiyAhmed, path = "./01 Raw dataset/about_drAbiyAhmed.csv")
readr::write_csv(x = about_lalibela, path = "./01 Raw dataset/about_lalibela.csv")

## Get all comments for a specific topic
# topic_id <- about_ethiopia %>% 
#   dplyr::filter(row_number() == 2) %>% 
#   dplyr::pull(video_id) %>% 
#   as.character()

topic_id <- about_lalibela %>% 
  dplyr::filter(row_number() == 6) %>% 
  dplyr::pull(video_id) %>% 
  as.character()

# commments_ethiopia <- tuber::get_all_comments(video_id = topic_id)
commments_lalibela <- tuber::get_all_comments(video_id = topic_id)

## Save comments
# readr::write_csv(x = commments_ethiopia, path = "./01 Raw dataset/commments_ethiopia.csv")
readr::write_csv(x = commments_lalibela, path = "./01 Raw dataset/commments_lalibela.csv")








