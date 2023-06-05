# aggregate crashes by hex

# spatial join to correlate pts to hex
pts_to_hex <- st_join(atx_crash_pts, travis_grid)

# drop geometry for calculations
st_geometry(pts_to_hex) <- NULL

# summarize crash data per hex
f.crhs_per_hex <- pts_to_hex %>% 
  mutate(crash_fatal_fl = if_else(
    crash_fatal_fl == "Y", 1,0)
         ) %>% 
  group_by(hex_id) %>% 
  summarize(crash_cnt = sum(crash_fatal_fl),
            death_cnt = sum(death_cnt))

# rejoin to travis grid
f.crsh_aggregate <- travis_grid %>% 
  left_join(f.crhs_per_hex) %>% 
  mutate_if(is.numeric, ~replace(., is.na(.), 0))

# save shapefile
dir.create(path = "data/f.crsh_aggregate")
st_write(f.crsh_aggregate, "data/f.crsh_aggregate.shp")


# Map ---------------------------------------------------------------------

ggplot() +
  geom_sf(data = f.crsh_aggregate,
          color = "black",
          aes(fill = crash_cnt)) +
  labs(title = "Concentration of Fatal Crashes in Travis County",
       subtitle = "2013-2023",
       caption = "source: City of Austin") +
  scale_fill_viridis_c("Fatal Crashes",
                       option = "H") +
  theme_void() +
  theme(legend.position = "bottom")
