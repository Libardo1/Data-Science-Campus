###################################
## load Heart Disease dataset
###################################
## first heart dataset
data("heart_disease_cl", package = "ucidata")
readr::write_csv(x = heart_disease_cl, path = "./00 Raw dataset/heart_disease_cl.csv", 
                 col_names = T)

## second heart dataset
data("heart_disease_hu", package = "ucidata")
readr::write_csv(x = heart_disease_hu, path = "./00 Raw dataset/heart_disease_hu.csv", 
                 col_names = T)

## third heart dataset
data("heart_disease_va", package = "ucidata")
readr::write_csv(x = heart_disease_va, path = "./00 Raw dataset/heart_disease_va.csv", 
                 col_names = T)

## fourth heart dataset
data("heart_disease_ch", package = "ucidata")
readr::write_csv(x = heart_disease_ch, path = "./00 Raw dataset/heart_disease_ch.csv", 
                 col_names = T)