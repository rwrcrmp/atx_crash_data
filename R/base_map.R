# base map script

library(tidyverse)
library(sf)

# Prelim setup ------------------------------------------------------------

# https://tnr-traviscountytx.opendata.arcgis.com/datasets/TravisCountyTX::boundary/explore?location=30.324646%2C-97.770000%2C10.82
travis_boundary <- st_read("Desktop/atx_crash_data/Boundary/Boundary.shp")

ggplot(travis_boundary) +
  geom_sf()

# https://data.austintexas.gov/dataset/Street-Centerline/8hf2-pdmb
road_segments <- st_read("Desktop/atx_crash_data/Street Centerline/geo_export_99c4ed0d-9896-47a9-9377-143227d0fbc8.shp")

road_segments <- st_transform(road_segments, st_crs(travis_boundary))

IH_35 <- road_segments %>% 
  dplyr::filter(str_detect(street_nam, "IH 35"))

ggplot(IH_35) +
  geom_sf()

# Isolate IH 35 segments --------------------------------------------------












