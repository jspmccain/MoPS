#functions to move odf files to BBMP FTP, and convert to .csv files as well.

###
#odf_file_renamer: converts to new file name, also tolerant of naming convention in Src.
#transfer_files_odf: transfers files from the arc or src (depending which is available) in odf.
#transfer_files_csv: transfers files from arc or src in csv.
###

library(magrittr)
library(dplyr)
library(testthat)
library(stringr)

# setwd("R:\\Science\\BIODataSvc\\ARC\\Archive\\ctd\\2000")

'%!in%' <- function(x,y)!('%in%'(x,y))

#function to rename the files to a standard format.
odf_file_renamer <- function(odf_file_i, file_extension = "ODF", src_format = TRUE){

  # odf_file_i <- "CTD_BCD2000667_75_1_DN.ODF"
  #ensuring that the function argument is a character object (the file name)
  expect_that(odf_file_i, is_a("character"))

  if(file_extension %!in% c("ODF", "csv")){
    stop("File extension is not available.")
  }

  if(src_format){
    #read in the file as an odf to extract the year
    odf_read_in <- read.odf(odf_file_i)
    year_date <- format(odf_read_in[["date"]], "%Y")
    front_string <- "CTD_BCD"
    #get the number associated with the file (e.g. 001)
    cast_number <- substr(odf_file_i, nchar(odf_file_i) - 6, nchar(odf_file_i) - 4)
    #put the total file name together
    final_file_name <- paste(front_string,
                             year_date,
                             "667_",
                             cast_number,
                             "_01_DN.",
                             file_extension,
                             sep = "")
  } else {
    final_file_name <- paste(str_sub(odf_file_i, start = 1, end = -4), file_extension, sep = "")
    }
  return(final_file_name)
}

# odf_file_renamer("D11667042.ODF")
# odf_file_renamer("CTD_BCD2011667_042_01_DN.ODF", src_format = FALSE)

#function for transferring and renaming files from the COMPASS shared files, to the BBMP website folder
transfer_files_odf <- function(year){
  #### 
  #This function copies files from the Arc, to the BBMP website FTP. 
  #Input is just one year.
  ###
  # year <-2007
  odf_files <- directory_lister_wrapper(year_x = year)
  no_odf_files <- length(odf_files)

  out_file_dir_base <- paste("R:\\Shared\\Cogswell\\_BIOWeb\\BBMP\\ODF\\",
          year, "\\",
          sep="")
  
  for(i in 1:no_odf_files){
    
    new_file_name <- odf_file_renamer(odf_file_i = odf_files[i], 
                                      src_format = use_src, 
                                      file_extension = "ODF")
    
    start_file <- paste(used_directory, "\\", odf_files[i], sep = "")
    
    out_file <- paste(out_file_dir_base, new_file_name)
    
    file.copy(from = start_file, to = out_file)
    
    print(out_file)
    
  }
}

# transfer_files_odf(year = 2008)

substr_right <- function(x, n){
  ###
  #Function for taking the substring to the right of string x, n times
  ###
  substr(x, nchar(x) - n + 1, nchar(x))
}

transfer_files_csv <- function(year){
  #### 
  #This function copies files from the Arc, to the BBMP website FTP. 
  #ODF File is converted to a .csv
  #Input is just one year.
  ### 
  # year <- 2017
  odf_files <- directory_lister_wrapper(year_x = year)
  no_odf_files <- length(odf_files)
  
  out_file_dir <- paste("R:\\Shared\\Cogswell\\_BIOWeb\\BBMP\\CSV\\",
          year, "\\",
          sep="")
  
  expect_true(no_odf_files > 0, info = "No files found.")
  
  for(i in 1:no_odf_files){
    # start_file <- paste(temp_wd, "\\", odf_files[i], sep = "")
    
    setwd(used_directory)
    new_odf_file_name <- odf_file_renamer(odf_file_i = odf_files[i], 
                                          src_format = use_src,
                                          file_extension = "csv")
    # new_odf_file_name <- paste(str_sub(odf_files[i], start = 1, end = -4), "csv", sep = "")
    opened_ctd_odf <- read.ctd.odf(odf_files[i])
    setwd(out_file_dir)
    write.ctd(opened_ctd_odf, file = paste(out_file_dir, new_odf_file_name, sep = ""))
    print(new_odf_file_name)
  }
}

# transfer_files_csv(year = 2017)
# transfer_files_odf(1999)

##testing opening some ODF files
# setwd("R:\\Science\\BIODataSvc\\ARC\\Archive\\ctd\\2008")
# read.odf("CTD_BCD2007667_001_01_DN.ODF")
# test <- read.ctd.odf("CTD_BCD2008667_001_01_DN.ODF")

# test@metadata$units

transfer_files_odf(2007)


#testing the writing of a readme file











