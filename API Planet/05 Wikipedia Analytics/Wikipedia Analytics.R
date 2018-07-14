
## load library and custom functions
source("./03 R programs/load library.R")

################################
## Get Wikipedia data
################################
## Import login credentials
credential_wiki <- readxl::read_excel(path = file.choose(), sheet = "Wikipedia", col_names = T)

# ## Login into Wikipedia page
# WikipediR::login(url = "https://en.wikipedia.org/w/index.php", 
#                  user = credential_wiki$username, pw = credential_wiki$password)


trend_data <- 
  wikipediatrend::wp_trend(
    page = c("ethiopia"), 
    lang = c("en"), 
    from = "2018-01-01",
    to   = "2018-01-30"
  )





