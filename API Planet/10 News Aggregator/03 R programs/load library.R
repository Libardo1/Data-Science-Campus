
library(tidyverse)
library(magrittr)
library(stringr)
library(lubridate)

library(newsAPI)      ## Installation -devtools::install_github("mkearney/newsAPI")
library(maps)         ## To check for world country / city if mentioned in a News 
library(plyr)         ## for manipulating world cities and countries (source: https://stackoverflow.com/questions/5318076/extracting-country-name-from-author-affiliations)
