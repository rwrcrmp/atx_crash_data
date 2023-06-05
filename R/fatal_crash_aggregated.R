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
st_write(f.crsh_aggregate, "f.crsh_aggregate.shp")
