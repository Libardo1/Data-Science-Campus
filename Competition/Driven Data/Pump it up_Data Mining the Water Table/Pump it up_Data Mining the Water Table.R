
## load library and custom functions
source("./03 R programs/load library.R")

## load raw datasets
training_orig <- readr::read_csv(file = file.choose(), col_names = T)
test_orig <- readr::read_csv(file = file.choose(), col_names = T)
target_training_orig <- readr::read_csv(file = file.choose(), col_names = T)


## Visualization
tanzania <- ggmap::get_map(location = 'Tanzania', zoom = 3)

ggmap(tanzania) + geom_point(data = training_orig, 
                                 aes(x = longitude, y = latitude), alpha = 0.5, color = "red") + 
  theme(legend.position = "right") + 
  labs(
    x = "Longitude", 
    y = "Latitude"
    # , title = ""
    # , caption = ""
    )
