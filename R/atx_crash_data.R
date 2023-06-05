library(tidyverse)
library(sf)
library(RSocrata)

# Prelim setup ------------------------------------------------------------

url <- "https://data.austintexas.gov/resource/y2wy-tgr5.json"

atx_crash_raw <- read.socrata(url)

write_csv(atx_crash_raw, "data/atx_crash_raw.csv")

atx_crash_raw <- read_csv("data/atx_crash_raw.csv")

# Build Shapefile -------------------------------------------------------

atx_crash_pts <- atx_crash_raw %>% 
  
  # keep only death count greater than 0
  filter(death_cnt != "0") %>% 
  # select(crash_id, longitude, latitude) %>% 
  
  # add geometry as points
  st_as_sf(coords = c("longitude", "latitude"),
           
           # conform CRS
           crs = st_crs(travis_grid)) %>% 
  filter(!is.na(geometry))

# save shapefile to data folder
dir.create(path = "data/atx_crash_pts")
st_write(atx_crash_pts, "data/atx_crash_pts/atx_crash_pts.shp")

# Map ---------------------------------------------------------------------

atx_crash_pts %>% 
  ggplot() +
  geom_sf(color = "firebrick", 
          size = 1,
          show.legend = FALSE) +
  labs(title = "Fatal Crashes in Austin, TX",
       subtitle = "2018-2023",
       caption = "source: City of Austin") +
  theme_void()
