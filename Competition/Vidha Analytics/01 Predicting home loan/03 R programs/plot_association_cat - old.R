
plot_association_cat <- function ( dsin = NULL,
                                   response_var = NULL,
                                   id_var = NULL ) {
  
  ## -- select categorical variables
  dsin_categorical <- dsin %>% 
    dplyr::select_if(is.character)
  
  ## -- remove id variable, if available
  if ( !is.na(id_var) ) {
    
    colnames_orig <- names(dsin_categorical)
    colnames_sel <- colnames_orig[!names(dsin_categorical) %in% id_var]
    
    dsin_categorical <- dsin_categorical %>% 
      dplyr::select( colnames_sel  )
  }
  
  ## -- reshape dataframe from wide to long
  dsin_categorical_long <- tidyr::gather(data = dsin_categorical, 
                                         variable_cat, 
                                         value_cat, 
                                         -response_var)
  
  ## -- plot barchart by variable
  ggplot(data = dsin_categorical_long, aes(value_cat)) +
    # geom_bar(aes(fill = response_var), width = 0.5) +
    geom_bar(aes_string(fill = response_var), width = 0.5) +           ## pass column name as string from function call (source: https://stackoverflow.com/questions/22309285/how-to-use-a-variable-to-specify-column-name-in-ggplot)
    facet_wrap(~ variable_cat, scales = "free")
}