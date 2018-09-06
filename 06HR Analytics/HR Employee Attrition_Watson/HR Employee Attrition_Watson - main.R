
## ---------------------
## load library
## ---------------------
source("./03 R programs/load library.R")

## ------------------------------
## load IBM Watson dataset
## ------------------------------
## Read raw dataset
ds_attrition_raw <- readxl::read_excel(path = file.choose(), 
                                       sheet = "WA_Fn-UseC_-HR-Employee-Attriti",
                                       col_names = T)

## Read variable label
ds_variable_label_raw <- readxl::read_excel(path = file.choose(), 
                                        sheet = "Data Definitions", 
                                        col_names = F)
colnames(ds_variable_label_raw) <- c("variable_raw", "value_raw")

## ------------------------------
## Preprocessing
## ------------------------------
## 1. preprocess variable label 
ds_variable_label <- ds_variable_label_raw %>% 
  dplyr::mutate(variable = as.character(variable_raw)) %>% 
  dplyr::group_by(variable) %>% 
  dplyr::mutate(from = unlist(stringr::str_extract_all(string = value_raw, 
                                                pattern = "\\d+"))) %>%  
  dplyr::mutate(to = unlist(stringr::str_extract_all(string = value_raw, 
                                              pattern = "(?<=').*?(?=')"))) %>%      ## extract everything between quotes (source: https://stackoverflow.com/questions/32320081/how-to-extract-text-between-quotations-in-r)
  # dplyr::mutate(label_sjlabelled = paste("'", from, "' = ", '"', to, '"', sep = "")) %>% 
  dplyr::mutate(label_sjlabelled = paste(from, " = ", '"', to, '"', sep = "")) %>% 
  dplyr::mutate(label_sjlabelled_collapsed = paste(label_sjlabelled, collapse = ",")) %>% 
  dplyr::select(-c(variable_raw,value_raw))

# ## save preprocess variable value dataset
# readr::write_csv(x = ds_variable_label,
#                  path = "./02 Analysis dataset/variable label.csv",
#                  col_names = T)


## 2. Preprocess dataset
education_label <- ds_variable_label %>% 
  dplyr::filter(variable == "Education") %>% 
  dplyr::pull(label_sjlabelled_collapsed) %>% 
  as.character() %>% 
  unique()

ds_attrition <- ds_attrition_raw %>% 
  dplyr::rename(Education_raw = Education) %>% 
  dplyr::mutate(Education_fct = sjlabelled::as_factor(Education_raw)) %>% 
  dplyr::mutate(Education = sjlabelled::set_labels(x = Education_fct, labels = education_label))        ## Bug01, 24-jun-2018: More values in "x" than length of "labels". Additional values were added to labels.





