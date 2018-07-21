
get_varMetadata <- function ( dsin = NULL,
                              id_var = NULL,
                              is_train = TRUE) {
  
  ## remove id variable, if available
  if ( !is.na(id_var) ) {
    
    colnames_orig <- names(dsin)
    colnames_sel <- colnames_orig[!names(dsin) %in% id_var]
    
    dsin <- dsin %>% 
      dplyr::select(colnames_sel)
  } 
    
  
  ## reshape dataframe from wide to long
  dsin_long <- tidyr::gather(data = dsin,
                             key_variable,
                             key_value)
  
  ## get total number of records per variable
  total <- dsin_long %>% 
    dplyr::group_by(key_variable) %>% 
    dplyr::summarise(total_records = n())
  
  ## count number of missing records per variable
  count_missing <- dsin_long %>% 
    dplyr::group_by(key_variable) %>% 
    dplyr::summarise(count_missing = sum(is.na(key_value)))
  
  ## get variable metadata to determine number of unique values
  metadata_variable <- dsin_long %>% 
    dplyr::group_by(key_variable) %>%  
    dplyr::distinct(key_value) %>%
    dplyr::summarise(value_unique = n()) %>% 
    dplyr::distinct(key_variable, value_unique) %>% 
    dplyr::mutate(flg_toFactor = ifelse(value_unique < 20, 
                                        T, F)) %>% 
    dplyr::select(key_variable, value_unique, flg_toFactor)
  
  ## create final metadata
  metadata_variable_final <- metadata_variable %>% 
    dplyr::inner_join(count_missing, by=c("key_variable" = "key_variable")) %>% 
    dplyr::inner_join(total, by=c("key_variable" = "key_variable")) %>% 
    dplyr::mutate(percent_missing = (count_missing / total_records)*100) %>% 
    dplyr::select(-c(count_missing, total_records)) %>% 
    dplyr::mutate(dsin_type = ifelse(!(is_train == T), 
                                     "test", "train"))
  
  ## return metadat
  return(metadata_variable_final)
}