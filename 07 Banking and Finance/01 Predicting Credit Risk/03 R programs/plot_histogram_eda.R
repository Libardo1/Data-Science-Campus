
plot_histogram_eda <- function ( dsin = NULL,
                                 metadata_variable = NULL,
                                 id_var = NULL ) {
  
  ## select numeric variables
  dsin_flt <- dsin %>% 
    dplyr::select_if(is.numeric)
  
  ## -- remove id variable, if available
  if ( !is.na(id_var) ) {
    
    colnames_orig <- names(dsin_flt)
    colnames_sel <- colnames_orig[!names(dsin_flt) %in% id_var]
    
    dsin_flt <- dsin_flt %>% 
      dplyr::select( colnames_sel  )
  } 
  
  ## -- reshape dataframe from wide to long
  dsin_flt_long <- tidyr::gather(data = dsin_flt,
                                 variable_cat,
                                 value_cat)
  
  # ## -- get variable metadata to determine number of unique values
  # metadata_variable <- dsin_flt_long %>% 
  #   dplyr::group_by(variable_cat) %>% 
  #   dplyr::distinct(value_cat) %>% 
  #   dplyr::mutate(count = n()) %>% 
  #   dplyr::distinct(variable_cat, count)

  # var_remove <- metadata_variable %>%
  #   dplyr::filter(count <= 20) %>%
  #   dplyr::pull(variable_cat) %>%
  #   as.character()
  
  var_remove <- metadata_variable %>%
    dplyr::filter(flg_toFactor == T) %>%
    dplyr::pull(key_variable) %>%
    as.character()
  
  ## --- exclude variables with few observations
  dsin_flt_long_final <- dsin_flt_long %>%
    dplyr::filter(!variable_cat %in% var_remove)
  
  
  ## plot histogram
  ggplot(data = dsin_flt_long_final, aes(value_cat)) +
    # geom_histogram(binwidth = 20) +
    geom_histogram() +
    facet_wrap(~ variable_cat, ncol = 2, scales = "free_x")
}