
plot_association_eda <- function ( dsin = NULL,
                                   response_var = NULL,
                                   plot_type = NULL,
                                   id_var = NULL ) {
  
  ## -- select categorical variables
  if ( plot_type == "barplot" ) {
    # dsin_flt <- dsin %>% 
    #   dplyr::select_if(is.character)
    
    dsin_flt <- dsin %>% 
      dplyr::select_if(is.factor)
  }
  else if ( plot_type == "boxplot" ) {
    dsin_flt <- dsin %>% 
      dplyr::select_if(is.numeric)
    
    ## add response variable, applicable only for binary response
    response_var_df <- dsin %>%
      dplyr::select(dplyr::contains(response_var))

    dsin_flt <- data.frame(dsin_flt, response_var_df)
  }
  
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
                                 value_cat,
                                 -response_var)
  
  # dsin_flt_long <- tidyr::gather_(data = dsin_flt,
  #                                 "variable_cat",
  #                                 "value_cat",
  #                                 -colnames(dsin_flt)[response_var])
  
  ## -- plot response by class variable
  if ( plot_type == "barplot") {
    
    ggplot(data = dsin_flt_long, aes(value_cat)) +
      # geom_bar(aes(fill = response_var), width = 0.5) +
      geom_bar(aes_string(fill = response_var), width = 0.5) +           ## pass column name as string from function call (source: https://stackoverflow.com/questions/22309285/how-to-use-a-variable-to-specify-column-name-in-ggplot)
      facet_wrap(~ variable_cat, scales = "free")
  }
  else if ( plot_type == "boxplot") {
    
    ggplot(data = dsin_flt_long, aes_string(x = response_var, y = "value_cat")) +
      geom_boxplot() + 
      facet_wrap(~ variable_cat, scales = "free")
  }
}