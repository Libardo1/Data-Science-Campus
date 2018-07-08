
## load library
source("./03 R programs/load library.R")

## load Groupon open Campaign dataset
# json_campaign <- jsonlite::fromJSON(txt = file.choose())
# json_campaign <- RJSONIO::fromJSON(content = file.choose())
json_campaign <- ndjson::stream_in(path = file.choose())

campaign <-  dplyr::bind_rows(json_campaign)
