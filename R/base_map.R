library(tidyverse)
library(sf)

# Prelim setup ------------------------------------------------------------

counties <- st_read("data/Counties/geo_export_212e809f-c2c4-427c-b69f-e923db68b2c9.shp")

travis_boundary <- counties %>% 
  dplyr::filter(county_nam == "TRAVIS") %>% 
  select(county_nam, geometry)

road_segments <- st_read("data/Street Centerline/geo_export_2da675db-b505-4e2b-bc1a-8e738b82806c.shp")

# conform CRS
road_segments <- st_transform(road_segments, st_crs(travis_boundary))

# Manipulate shapefiles ---------------------------------------------------

# create hexgrid geometry
travis_grid <- travis_boundary %>% 
  
  # 39 hexes seems to create the minimum thickness
  # overlay with IH_35 without causing a visual error
  st_make_grid(n = 39, square = F, flat_topped = T) %>%
  st_intersection(travis_boundary) %>% 
  st_as_sf() %>% 
  
  # additional non-spatial variables
  mutate(
    
    # ad ids to hexes
    hex_id = row_number(),
    
    # add IH_35 T/F label
    IH_35_hex = if_else(
      as.character(st_intersects(
        ., 
        # "IH" identifies interstate in road segments
        dplyr::filter(road_segments, prefix_typ == "IH"))
                   ) != "integer(0)", 
      T, F
      )
    )

# save shapefile to data folder
dir.create(path = "data/travis_grid")
st_write(travis_grid, "data/travis_grid/travis_grid.shp")

# Map ---------------------------------------------------------------------

custom_palette <- c("#d8b365", "#5ab4ac")

# apply T/F to color pallete
names(custom_palette) <- levels(travis_grid$IH_35_hex)

ggplot() +
  geom_sf(data = travis_grid, aes(fill = IH_35_hex)) +
  labs(title = "IH 35 through Travis County",
      subtitle = "Blue hexes intersect with IH 35 footprint",
      caption = "source: City of Austin") +
  scale_fill_manual(values = custom_palette) +
  theme_void() +
  theme(legend.position = "none")
