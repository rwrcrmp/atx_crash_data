# atx transportation: crash data query

library(tidyverse)
library(RSocrata)

url <- "https://data.austintexas.gov/resource/y2wy-tgr5.json"

atx_crash_raw <- read.socrata(url)

write_csv(atx_crash_raw, "atx_crash_raw.csv")

atx_crash_raw <- read_csv("atx_crash_raw.csv")

# take a look at rpt_street_name
street_names <- levels(factor(atx_crash_raw$rpt_street_name))

# "IH 35" is standard notation for highway

IH35_reports <- atx_crash_raw %>% 
  mutate(IH35 = if_else(str_detect(rpt_street_name, "IH 35"), T, F))

IH35_reports %>% 
  count(IH35 == T)
