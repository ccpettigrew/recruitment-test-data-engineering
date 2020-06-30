# load libraries
library(tidyverse)
library(ggplot2)
library(lubridate)
library(jsonlite)

#load data
people <- read_csv('data/people.csv')
places <- read_csv('data/places.csv')

#tidying for join
people <- people %>%
  rename(city = place_of_birth)

#join
people_and_places <- inner_join(places, people, by = 'city')

#write to csv file
write_csv(people_and_places,'data/people_and_places.csv')

#analysis of records by country
summary_output <- people_and_places %>%
  group_by(country) %>%
  count() %>%
  arrange(desc(n))

#write to json
write_json(summary_output, "data/summary_output.json", pretty = TRUE, auto_unbox = TRUE)