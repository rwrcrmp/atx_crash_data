library(tidyverse)
library(sf)

# Prelim setup ------------------------------------------------------------

travis_boundary <- read_sf("data/Boundary/Boundary.shp")

ggplot(travis_boundary) +
  geom_sf()
 
road_segments <- read_sf("data/Street Centerline/geo_export_2da675db-b505-4e2b-bc1a-8e738b82806c.shp")

road_segments <- st_transform(road_segments, st_crs(travis_boundary))

ggplot(road_segments) +
  geom_sf()

# Isolate IH 35 segments --------------------------------------------------

IH_35 <- road_segments %>% 
  dplyr::filter(prefix_typ == "IH") %>% 
  select(geometry) %>% 
  bind_rows(
    select(travis_boundary, geometry)
  )

ggplot(IH_35) +
  geom_sf(color = "black") + 
  labs(title = "Travis Count & IH 35",
       caption = "sources: TXDOT & Travis County open data portals") +
  theme_void() +
  theme(plot.background = element_rect(fill = "blanchedalmond"))










