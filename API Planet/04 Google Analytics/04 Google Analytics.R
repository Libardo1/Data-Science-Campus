
## load library
source("./03 R programs/load library.R")

## Authenticate Google Analytics API
api_json <- ndjson::stream_in(path = file.choose())

# client_id <- api_json$web.client_id %>% 
#   as.character()

# RGoogleAnalyticsPremium::Auth(client.id = api_json$web.client_id, 
#                               client.secret = api_json$web.client_secret)

RGoogleAnalytics::Auth(client.id = api_json$web.client_id,
                       client.secret = api_json$web.client_secret)
