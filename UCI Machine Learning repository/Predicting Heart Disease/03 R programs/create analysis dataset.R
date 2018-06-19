## Cleveland dataset
heart_disease_cl <- readr::read_csv(file = file.choose(), col_names = T)
heart_disease_cl <- heart_disease_cl %>% 
  dplyr::mutate(data_source = "cl")

## Hungary dataset
heart_disease_hu <- readr::read_csv(file = file.choose(), col_names = T)
heart_disease_hu <- heart_disease_hu %>% 
  dplyr::mutate(data_source = "hu")

## Switzerland dataset
heart_disease_ch <- readr::read_csv(file = file.choose(), col_names = T)
heart_disease_ch <- heart_disease_ch %>% 
  dplyr::mutate(data_source = "ch")

## VA Long Beach dataset
heart_disease_va <- readr::read_csv(file = file.choose(), col_names = T)
heart_disease_va <- heart_disease_va %>% 
  dplyr::mutate(data_source = "va")

## combine all datasets
heart_disease_combined <- dplyr::bind_rows(heart_disease_cl, 
                                           heart_disease_hu, 
                                           heart_disease_ch, 
                                           heart_disease_va)

## add subject identifier
heart_disease_combined <- heart_disease_combined %>% 
  dplyr::mutate(id = 1:n())

## Save combined dataset
readr::write_csv(x = heart_disease_combined, 
                 path = "./01 Analysis dataset/heart_disease_combined.csv", 
                 col_names = T)