
## load library
source("./03 R programs/load library.R")

# ## Connect to Google Trends
# credential_gTrends <- readxl::read_excel(path = file.choose(), sheet = "GTrends", col_names = T)
# 
# usr <- credential_gTrends$gmail_userName
# psw <- credential_gTrends$gmail_password
# 
# gtrendsR::gconnect()   ## deprecated (source: https://github.com/PMassicotte/gtrendsR/issues/199)

# lang_trend <- gtrends(keyword = c("data is", "data are"), time = "now 7-d")
# plot(lang_trend)
# trend_obama <- gtrendsR::gtrends(keyword="obama",geo="US-AL-630")
# plot(trend_obama)

trend_ethiopia <- gtrendsR::gtrends(keyword = c("dr. abiy ahmed", "hailemariam desalegn"))
plot(trend_ethiopia)

## Sava raw dataset
readr::write_rds(x = trend_ethiopia, path = "./01 Raw dataset/trend_ethiopia.rds")

# trend <- gtrendsR::gtrends(keyword = "malaria", geo = "ET")
# plot(trend)

