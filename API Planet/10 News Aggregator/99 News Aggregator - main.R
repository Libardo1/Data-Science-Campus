
#################################################
## Inspired by 
## - https://github.com/mkearney/newsAPI
#################################################

## load library
source("./03 R programs/load library.R")

##--------------------------
## Connect to News API
##--------------------------
## Get API key
df_api_key <- readxl::read_xlsx(path = "./../../../../API/API Keys for R.xlsx", 
                                sheet = "News", col_names = T)

NEWSAPI_KEY <- df_api_key$api_key        ## the object name must be "NEWSAPI_KEY" since the package (newsAPI) is written on top of it.

## save to .Renviron file
cat(
  paste0("NEWSAPI_KEY=", NEWSAPI_KEY),
  append = TRUE,
  fill = TRUE,
  file = file.path("~", ".Renviron")
)

## ---------------------------------------------------
## Get articles from newsAPI
## - source: https://github.com/mkearney/newsAPI
## ---------------------------------------------------
## get all english language news sources (made available by newsapi.org)
src <- newsAPI::get_sources(language = "en")

## apply get_articles function to each news source
df <- lapply(src$id, get_articles)

## collapse into single data frame
df <- do.call("rbind", df)

## Save dataset
filename_out <- file.path(paste("./02 Analysis dataset/all news_", 
                                lubridate::today(), ".csv", sep = ""))

readr::write_csv(x = df, path = filename_out)

## ------------------------------------------
## Building News classification algorithm
## ------------------------------------------
df_complete <- df %>% 
  dplyr::filter(complete.cases(description))

# df_flt <- df_complete[stringr::str_detect(string = df_complete$description, 
#                                           regex(pattern = "kenya", 
#                                                 ignore_case = TRUE)), ]



