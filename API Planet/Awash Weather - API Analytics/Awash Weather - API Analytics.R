
## Inspired by: Public API (https://github.com/toddmotto/public-apis)


## load library
source("./03 R programs/load library.R")

## Make API call
url_weather <- "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22nome%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
weather <- httr::GET(url = url_weather)
