library(tidyverse)
library(sf)
library(leaflet)
library(htmlwidgets)

travis_grid <- st_read("data/f.crsh_aggregate/f.crsh_aggregate.shp")

# leaflet ----------------------------------------------------------------

# labels <- sprintf("Fatal Crashes <strong>%s</strong>",
#                   travis_grid$crash_cnt) %>% 
#           lapply(htmltools::HTML)

labels <- sprintf(as.character(travis_grid$crash_cnt))
  
pal <- colorNumeric(palette = "magma", 
                    domain = travis_grid$crash_cnt)

t <- travis_grid %>% 
  leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
  addProviderTiles(providers$CartoDB) %>% 
  setView(lng = -97.78181,
          lat = 30.33422,
          zoom = 10) %>% 
  addPolygons(label = labels,
              stroke = FALSE,
              color = "grey",
              smoothFactor = .5,
              opacity = 1,
              fillOpacity = 0.3,
              fillColor = ~pal(crash_cnt),
              highlightOptions = 
                highlightOptions(weight = 2,
                                 fillOpacity = 1,
                                 color = "white",
                                 opacity = 1,
                                 bringToFront = TRUE)) %>%
  addLegend(pal = pal,
            values = ~crash_cnt,
            title = "Fatal Crashes",
            position = "topleft")
  
saveWidget(t, "travis_crashes_hex.html")

