# Ask a good question -----------------------------------------------------

# Read data --------------------------------------------------------------- 

library(tidyverse) # readr
library(rattle) # normvarnames

ozone <- read_csv("~/Documents/Learn/R/EDA Peng/data/hourly_44201_2014.csv", 
                  col_types = "ccccinnccccccncnnccccccc")

names(ozone) <- normVarNames(names(ozone))

# Check the packaging -----------------------------------------------------

nrow(ozone)
ncol(ozone)


# Run glimpse() -----------------------------------------------------------

glimpse(ozone)


# Look at top and bottom --------------------------------------------------

head(ozone)
tail(ozone)


# Check "n"s --------------------------------------------------------------

# hourly?

ozone %>% 
  group_by(time_local) %>% 
  summarise(n = n())

# all US states are 50
ozone %>% 
  summarise(n_distinct(state_name))

ozone %>% 
  distinct(state_name)



# Validate with external source -------------------------------------------



# Easy solutions first ----------------------------------------------------

# Which counties in the United States have the highest levels of ambient ozone pollution?

(ranking <- 
  ozone %>% 
  group_by(state_name, county_name) %>% 
  summarise(ozone = mean(sample_measurement)) %>% 
  arrange(desc(ozone)))

# Top 10 highest

ranking %>% head(10)

# Top 10 lowest

ranking %>% tail(10)


# Examine California 

ozone %>% 
  filter(state_name == "California" & county_name == "Mariposa") %>% 
  nrow()
