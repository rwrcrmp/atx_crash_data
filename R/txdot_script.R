
# txdot roadway inventory w/ vehicle miles travelled.
# practice building API query

setwd("~/Desktop/atx_crash_data")

library(readxl)

txdot_url <- "https://ftp.txdot.gov/pub/txdot-info/tpp/roadway-inventory/data-table.xlsx"

download.file(url = txdot_url, destfile = "txdot_roadway_inventory.xlsx")

roadway_inventory <- read_xlsx("txdot_roadway_inventory.xlsx", sheet = 3)

        