#!/usr/bin/env Rscript

## Electric Power Consumption Assignment

## plot2.R
## by Mark Chang


library("data.table")
require(data.table)

# Windows
setwd("C:\\Users\\mchang\\Projects\\ProgrammingAssignment5")

# Mac
# setwd("/Users/mchang/Projects/ProgrammingAssignment4")

path <- getwd()
datasetpath <- file.path(path,"dataset")
datafilename <- "dataFiles.zip"

#if ( !dir.exists(datasetpath))
#{
#    dir.create(datasetpath)
#} else
#{
#   unlink(datasetpath, recursive = TRUE)
#}

# Download file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#download.file(url, file.path(path, datafilename))
#unzip(zipfile = datafilename, exdir = datasetpath)

#file.rename ( from = "UCI HAR Dataset", to = datasetpath)

## Noticed that there are a few records with ?. Need to record them
## as NA strings
#electricity <- fread("dataset\\household_power_consumption.txt")
electricity <- fread("dataset\\household_power_consumption.txt", na.strings = "?")

## Change global_active_power to not print in scientific notation
## modify in place using example from https://r-statistics.co/base-lapply-in-R.html
column_modify1 <- c("Global_active_power")
electricity[,(column_modify1) := lapply(.SD, as.numeric), .SDcols = column_modify1]

## As suggested, change date column to Date class. Modify in place
column_modify2 <- c("Date")
#electricity[,(column_modify2) := lapply(.SD, as.Date), .SDcols = column_modify2]
# Need to specify format for date!!
electricity[,(column_modify2) := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = column_modify2]


## And filter for correct dates
electricity2 <- electricity[(Date >= "2007-02-01") & (Date <= "2007-02-02" )]

png("plot2.png",width=480,height=480)

