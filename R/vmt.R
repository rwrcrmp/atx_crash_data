library(tidyverse)
library(readxl)
library(sf)


# xslx source -------------------------------------------------------------

### USE THIS METHOD FOR MULTIPLE TABLES ###

# path <- "data/data-table.xlsx"
# 
# sheet_names <- c("G1 On-System CL Miles Route",
#                  "G2 On-System Lane Miles Route",
#                  "G3 On-System Truck DVMT Route",
#                  "G4 On-System Total DVMT Route")
# 
# vmt <- lapply(sheet_names, function(x){
#   read_excel(path, sheet = x)
# })
# 
# names(vmt) <- strsplit(sheet_names, ",")
# 
# list2env(vmt, envir = .GlobalEnv)
#
### USE THIS METHOD FOR ONE TABLE ###

vmt <- as.data.frame(read_xlsx("data/data-table.xlsx", 
                     sheet = "G4 On-System Total DVMT Route"))

#pull column names from row 2
names(vmt) <- as.vector(vmt[2,])

# remove rows 1 & 2
vmt <- vmt[-(1:2),]

# extract base variables
vmt_base <- vmt[,(1:4)]
  
# build top variables
# there's got to be a better way to iterate over this

vmt_2018 <- cbind(vmt_base, vmt[,(5:7)]) %>% 
  mutate(year = 2018) %>% 
  rename(total = `2018 Total`)

vmt_2019 <- cbind(vmt_base, vmt[,(8:10)]) %>% 
  mutate(year = 2019) %>% 
  rename(total = `2019 Total`)

vmt_2020 <- cbind(vmt_base, vmt[,(11:13)]) %>% 
  mutate(year = 2020) %>% 
  rename(total = `2020 Total`)

vmt_2021 <- cbind(vmt_base, vmt[,(14:16)]) %>% 
  mutate(year = 2021) %>% 
  rename(total = `2021 Total`)

vmt_long <- rbind(vmt_2018, vmt_2019, vmt_2020, vmt_2021) %>% 
  rename(county = `County Name`,
         county_code = `TxDOT County Code`,
         dist_name = `TxDOT \r\nDistrict Name`,
         route_name = `On-System Route Name`,
         mainlines = `Mainlanes`,
         frontage = `Frontage`)

# isolate Austin District
atx_district <- vmt_long %>% 
  filter(dist_name == "Austin")

# api source --------------------------------------------------------------

txdot_roadway_opendata <- read_csv("data/TxDOT_Roadway_Inventory.csv")

# from documentation variables of interest are:
# RTE_GRID - Native GRID ID (Geospatial Roadway Inventory Database) for each route
# GID - Native GRID ID for each route / roadbed segment
# STE_NAM - Street Name
# CO - State county number, not FIPS county number
# F_SYSTEM & RU_F_SYSTEM - city and rural classification id number
# ADT_YEAR - annual daily traffic year
# ADT_CUR - AADT-CURRENT
# DVMT - daily vehicle miles of travel
# DTRKVMT - daily vehicle truck miles of travel
# HWY, HNUM, HSYS, 

travis_county1 <- txdot_roadway_opendata %>%
  filter(CO == 227) %>% 
  select(HWY, RTE_GRID, GID, STE_NAM, CO, F_SYSTEM,
         RU_F_SYSTEM, ADT_YEAR, ADT_CUR, DVMT, DTRKVMT)


# api shapefile -----------------------------------------------------------

# I think this one is the best
vmt_shape <- st_read("data/TxDOT_Roadway_Inventory/TxDOT_Roadway_Inventory_.shp")

atx_dist_vmt_geo <- vmt_shape %>% 
  select(
    # geo locations
    DI, CO, CITY, MPA,
    
    #geo identifiers, i think
    RTE_GRID, GID,
    
    # classifications
    STE_NAM, HWY, F_SYSTEM, RU_F_SYSTE,
    
    # stats
    ADT_YEAR, ADT_CUR, DVMT, DTRKVMT
    ) %>% 
  filter(DI == 14)

















