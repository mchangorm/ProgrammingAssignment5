#!/usr/bin/env Rscript

## Electric Power Consumption Assignment

## plot2.R
## by Mark Chang


library("data.table")
#library("lubridate")

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

## As suggested, change date column to Date class. This time, we need to take into account
## the time and combine the 2 separate columns together using the paste function
## and put them as a Date Time class which means we will need to use the as.POSIXct method
electricity[, DateTime := paste(Date,Time)]
electricity[, DateTime := as.POSIXct(DateTime,format="%d/%m/%Y %H:%M:%S")]
electricity[, DayWeek := as.factor(weekdays(DateTime, abbreviate = TRUE))]

## And filter for correct dates
electricity2 <- electricity[(DateTime >= "2007-02-01") & (DateTime <= "2007-02-03")]

png("plot2.png",width=480,height=480)

## This produces a scatter plot which is obviously wrong
## Need to find the correct plot type
#plot(x=electricity2[,DateTime],y=electricity2[,Global_active_power])
## Found it! It is type = "l" for a line plot.
#plot(x=electricity2[,DateTime],y=electricity2[,Global_active_power], type = "l")

## Cool now we need to change the data labels and the axis labels
#plot(x=electricity2[,DateTime],y=electricity2[,Global_active_power], type = "l", xlab="", ylab="Global Active Power (kilowatts)")

## Need to figure out how to make the date in the abbreviated day of week
## Got it! It is format(date,%a) and inserting them into plot
## Plot the graph with xaxt = n so that x axis is not drawn
## then add custom x-asis
plot(x=electricity2[,DateTime],y=electricity2[,Global_active_power], type = "l", xlab="", ylab="Global Active Power (kilowatts)",xaxt = "n")

## Then add the x-axis
axis(1, at = electricity2[,DateTime], labels = electricity2[,DayWeek])

dev.off()
