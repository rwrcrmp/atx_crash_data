# atx transportation: crash data query

library(tidyverse)
library(RSocrata)
library(lubridate)

url <- "https://data.austintexas.gov/resource/y2wy-tgr5.json"

atx_crash_raw <- read.socrata(url)

write_csv(atx_crash_raw, "data/atx_crash_raw.csv")

atx_crash_raw <- read_csv("data/atx_crash_raw.csv")

# take a look at rpt_street_name
street_names <- levels(factor(atx_crash_raw$rpt_street_name))

# "IH 35" is standard notation for highway

IH35_reports <- atx_crash_raw %>% 
  mutate(IH35 = if_else(str_detect(rpt_street_name, "IH 35"), T, F))

IH35_reports %>% 
  count(IH35 == T)

atx_crash_coords <- atx_crash_raw %>% 
  filter(crash_date >= "2018-01-01",
         death_cnt != "0") %>% 
  select(latitude, longitude) %>% 
  drop_na()

atx_crash_shp <- st_as_sf(atx_crash_coords, coords = c("longitude", "latitude"), crs = st_crs(travis_boundary))

atx_crash_shp %>% 
  ggplot() +
  geom_sf(color = "firebrick", 
          size = 1,
          show.legend = FALSE) +
  labs(title = "Fatal Crashes in Austin, TX",
       subtitle = "2018-2023",
       caption = "source: Austin Open Data Portal") +
  theme_void()
