library(tidyverse)
library(readxl)


# xslx source -------------------------------------------------------------

path <- "data/data-table.xlsx"

sheet_names <- c("G1 On-System CL Miles Route",
                 "G2 On-System Lane Miles Route",
                 "G3 On-System Truck DVMT Route",
                 "G4 On-System Total DVMT Route")

vmt <- lapply(sheet_names, function(x){
  read_excel(path, sheet = x)
})

names(vmt) <- strsplit(sheet_names, ",")

list2env(vmt, envir = .GlobalEnv)

vmt <- as.data.frame(read_xlsx("data/data-table.xlsx", 
                     sheet = "G4 On-System Total DVMT Route"))

names(vmt) <- as.vector(vmt[2,])

vmt <- vmt[-(1:2),]

vmt_base <- vmt[,(1:4)]

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

travis_county <- vmt_long %>% 
  filter(county_code == "227")


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

travis_county <- txdot_roadway_opendata %>%
  filter(CO == 227) %>% 
  select(RTE_GRID, GID, STE_NAM, CO, F_SYSTEM,
         RU_F_SYSTEM, ADT_YEAR, ADT_CUR, DVMT, DTRKVMT)

# just for fun, let's isolate IH_35

test <- as.data.frame(unique(travis_county$STE_NAM))

write_csv(test, "data/test.csv")

# hmm, seems like CO code filters our IH_35

test <- txdot_roadway_opendata %>% 
  filter(HSYS == "IH")




























