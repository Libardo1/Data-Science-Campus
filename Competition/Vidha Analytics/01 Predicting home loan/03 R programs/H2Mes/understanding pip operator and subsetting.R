

## req 1. create dataset of married applicants with their education background and employment status
## req 2. sort dataset
## Tips: use training dataset only
train
# head(train)
my_data=train[train$Married=="Yes",c("Education","Self_Employed")] 
summary(my_data)

report <- train %>% 
  dplyr::filter(Married=="Yes") %>% 
  dplyr::group_by(Education, Self_Employed) %>% 
  dplyr::summarise(frequency = n()) %>% 
  dplyr::arrange(desc(frequency))
  

train[train$Married=="Yes",c("Education","Self_Employed")]
