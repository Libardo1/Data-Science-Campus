
plot_association_cat <- function ( dsin = NULL,
                                   response_var = NULL,
                                   id_var = NULL ) {
  
  ## -- select categorical variables
  dsin_categorical <- dsin %>% 
    dplyr::select_if(is.character)
  
  ## -- remove id variable, if specified
  if ( !is.na(id_var) ) {
    
    colnames_orig <- names(dsin_categorical)
    colnames_sel <- colnames_orig[!names(dsin_categorical) %in% id_var]
    
    # dsin_categorical <- subset(x = dsin_categorical, subset = -c(id_var))
    dsin_categorical <- dsin_categorical %>% 
      dplyr::select( colnames_sel  )
  }
  
  ## -- reshape dataframe for multiple plots
  dsin_categorical_long <- tidyr::gather(data = dsin_categorical, 
                                         variable_cat, 
                                         value_cat, 
                                         # -response_var)
                                         -Loan_Status)
  
  ## Visualization of categorical variables
  # response_var <- subset(x = dsin_categorical_long, subset = response_var)
  
  ggplot(data = dsin_categorical_long, aes(value_cat)) +
    # geom_bar(aes(fill = response_var), width = 0.5) + 
    geom_bar(aes(fill = Loan_Status), width = 0.5) + 
    facet_wrap(~ variable_cat, scales = "free")
}