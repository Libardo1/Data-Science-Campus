
######################################################################################################################
## Inspired by 
## - http://rstudio-pubs-static.s3.amazonaws.com/371621_1690f6fffbb94c9b87637ede3e5ede00.html#21_who
######################################################################################################################

## load library
source("./03 R programs/load library.R")

################################
## Get disease codes
################################
code_disease <- WHO::get_codes()

## ------------------------------------
## Search for HIV/AIDS disease code
## ------------------------------------
flg_hiv <- code_disease[stringr::str_detect(string = code_disease$display, 
                                            regex(pattern = "(hiv)|(aids)", 
                                                  ignore_case = TRUE)), ]

## Save code
readr::write_csv(x = flg_hiv, path = "./02 Analysis dataset/WHO_code_HIV.csv")

## ----------------------------------
## Search for Malaria disease code
## ----------------------------------
flg_malaria <- code_disease[stringr::str_detect(string = code_disease$display, 
                                                regex(pattern = "(malaria)", 
                                                      ignore_case = TRUE)), ]

## Save code
readr::write_csv(x = flg_malaria, path = "./02 Analysis dataset/WHO_code_malaria.csv")

######################################################
## Get dataset for analysis - malaria as show case
######################################################
## Get all cause of malaria deaths ()

data <- WHO::get_data(code = "MALARIA_16231") 
# %>%
#   tidyr::separate(value, c("value", "ci"), sep = " ") %>%
#   mutate(ci = stringr::str_replace(ci, "\\[", ""), 
#          ci = stringr::str_replace(ci, "\\]", "")) %>%
#   tidyr::separate(ci, remove = FALSE, c("lower", "upper"), sep = "-") %>%
#   mutate_at(.vars = c("value", "lower", "upper"), .funs = as.numeric) 
# %>%
#   filter(region == "Europe", sex == "Female") %>%
#   ggplot(aes(year, value, colour = country)) +
#   geom_line(aes(group = country)) +
#   #facet_grid(agegroup~sex) +
#   theme(legend.position = "bottom") -> g
# plotly::ggplotly(g)










