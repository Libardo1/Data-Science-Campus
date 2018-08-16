
############################################################################################
## Inspired by:
## - How the package works? http://thinktostart.com/analyzing-facebook-with-r/
## - To get token as suggested in https://github.com/pablobarbera/Rfacebook/issues/77
############################################################################################


## load library
source("./03 R programs/load library.R")

## Import API key
api_key <- readxl::read_xlsx(path = "./../../../../API/API Keys for R.xlsx", 
                             sheet = "Facebook", col_names = TRUE)

app_id <- api_key$app_id
app_secret <- api_key$app_secret
app_token <- api_key$app_token
user_token <- api_key$user_token

#############################
## Connect to Facebook
#############################
# fb_oauth <- Rfacebook::fbOAuth(app_id = app_id, app_secret = app_secret, 
#                                extended_permissions = TRUE)

## Suggested by alexgithub56 (source: https://github.com/pablobarbera/Rfacebook/issues/77)
# me <- Rfacebook::getUsers(users = "me", token = app_token, 
#                           private_info = TRUE)

me <- Rfacebook::getUsers(users = "me", token = user_token, 
                          private_info = TRUE)
# my_likes <- Rfacebook::getLikes(user = "me", token = user_token)

obama <- Rfacebook::getUsers(users = "barackobama", token = user_token)

data_fb <- Rfacebook::getPage(page = "facebook", token = user_token, 
                              since = "2018/06/01", until = "2018/08/15", n = 20000)




