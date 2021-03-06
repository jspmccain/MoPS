#Plotting the weekly CTD Data

library(ggplot2)
library(magrittr)
library(testthat)
library(dplyr)
library(oce)
library(ocedata)
library(Hmisc)
library(RColorBrewer)
library(lubridate)
library(stringr)

total_df <- data.frame(pressure = numeric(),
                       temperature = numeric(),
                       conductivity = numeric(),
                       oxygenCurrent = numeric(),
                       oxygenTemperature = numeric(),
                       unknown = numeric(),
                       fluorometer = numeric(),
                       par = numeric(),
                       salinity = numeric(),
                       oxygen = numeric(),
                       sigmaTheta = numeric(),
                       flagArchaic = numeric(),
                       time_string = as.POSIXct(character()),
                       year_time = character(), 
                       month_time = character(),
                       julian_day = numeric())

year_available <- c(1999:format(Sys.Date(), "%Y") %>% as.numeric())

for(j in 1:length(year_available)){
  
    year <- year_available[j]
    odf_files <- directory_lister_wrapper(year, site_code = "667")
    no_odf_files <- length(odf_files)
    
  for(i in 1:no_odf_files){
      print(i)
      opened_ctd_odf <- read.ctd.odf(odf_files[i])
      odf_df <- as.data.frame(opened_ctd_odf@data)
      
      time_string <- rep(opened_ctd_odf[["startTime"]], nrow(odf_df))
      year_time <- rep(format(opened_ctd_odf[["startTime"]], "%Y") %>% as.numeric(), nrow(odf_df))
      month_time <- rep(format(opened_ctd_odf[["startTime"]], "%m") %>% as.numeric(), nrow(odf_df))
      day_time <- rep(format(opened_ctd_odf[["startTime"]], "%d") %>% as.numeric(), nrow(odf_df))
      julian_day <- rep(yday(opened_ctd_odf[["startTime"]]), nrow(odf_df))

      odf_df1 <- data.frame(time_string, year_time, month_time, day_time, julian_day, odf_df)

      total_df <- bind_rows(odf_df1, total_df)
  }
}


total_df["time"] <- NULL

total_df2 <- total_df[order(total_df$time_string, decreasing = FALSE), ]

#writing the entire file:

write.csv(x = total_df2, 
          row.names = FALSE, 
          file = "R:\\Shared\\Cogswell\\_BIOWeb\\BBMP\\CSV\\bbmp_aggregated_profiles.csv")

# 
# write.csv(x = total_df2, 
#           row.names = FALSE, 
#           file = "C:\\Users\\mccains\\Documents\\Data Testing\\bbmp_aggregated_profiles.csv")
  
  
  
  
  
  









