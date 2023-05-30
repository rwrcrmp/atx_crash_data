library(tidyverse)
library(sf)

# Prelim setup ------------------------------------------------------------

# read shapefiles
travis_boundary <- st_read("data/Boundary/Boundary.shp")

# convert to polygon
travis_boundary <- st_cast(travis_boundary$geometry, "POLYGON")

road_segments <- st_read("data/Street Centerline/geo_export_2da675db-b505-4e2b-bc1a-8e738b82806c.shp")

# conform CRS
road_segments <- st_transform(road_segments, st_crs(travis_boundary))

# Manipulate shapefiles ---------------------------------------------------

# create hexgrid
travis_grid <- travis_boundary %>%
  st_transform(st_crs(travis_boundary)) %>% 
  st_make_grid(n = 39, square = F, flat_topped = T) %>%
  st_intersection(travis_boundary) %>%
  st_as_sf()

# isolate IH 35 segments
IH_35 <- road_segments %>% 
  dplyr::filter(prefix_typ == "IH")

# identify hexes that contain highway
IH_35_hex <- travis_grid[IH_35, op = st_intersects]
IH_35_hex$y <- T

travis_grid <- travis_grid %>%
  st_join(IH_35_hex) %>% 
  mutate(y = if_else(!is.na(y), y, F))

# Map ---------------------------------------------------------------------

ggplot() +
  geom_sf(data = travis_grid, aes(fill = y)) +
  labs(title = "IH 35 area in Travis County",
       subtitle = "Blue hexes intersect with IH 35 footprint",
       caption = "sources: Travis County & City of Austin \nOpen Data Portals") +
  theme_void() +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "blanchedalmond"))
