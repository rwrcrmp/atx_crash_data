library(tidyverse)
library(readxl)

path <- "data/data-table.xlsx"

sheet_names <- c("G1 On-System CL Miles Route",
                 "G2 On-System Lane Miles Route",
                 "G3 On-System Truck DVMT Route",
                 "G4 On-System Total DVMT Route")

vmt <- lapply(sheet_names, function(x){
  read_excel(path, sheet = x)
})

names(vmt) <- strsplit(sheet_names, ",")

for(i in 1:length(vmt)){
   x <- data.frame(vmt[i])
}

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









