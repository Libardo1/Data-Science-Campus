
preprocess_varTypes <- function(dsin = NULL,
                                metadata_variable = NULL) {
  
  ## Get list of variables with corresponding type
  list_vars_toFactor <- metadata_variable %>% 
    dplyr::filter(flg_toFactor == T) %>% 
    dplyr::pull(key_variable) %>% 
    as.character()
  
  list_vars_toNumeric <- metadata_variable %>% 
    dplyr::filter(flg_toFactor == F) %>% 
    dplyr::pull(key_variable) %>% 
    as.character()
  
  ## adjust variable type
  dsout <- dsin %>% 
    dplyr::mutate_at(vars(list_vars_toFactor), funs(factor)) %>% 
    dplyr::mutate_at(vars(list_vars_toNumeric), funs(as.numeric))
  
  return(dsout)
}