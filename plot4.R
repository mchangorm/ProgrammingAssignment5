#!/usr/bin/env Rscript

## Electric Power Consumption Assignment

## plot4.R
## by Mark Chang

library("data.table")
#library("lubridate")

# Windows
setwd("C:\\Users\\mchang\\Projects\\ProgrammingAssignment5")

# Mac
#setwd("/Users/mchang/Projects/ProgrammingAssignment5")

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
download.file(url, file.path(path, datafilename))
unzip(zipfile = datafilename, exdir = datasetpath)

#file.rename ( from = "UCI HAR Dataset", to = datasetpath)

## Noticed that there are a few records with ?. Need to record them
## as NA strings
#electricity <- fread("dataset\\household_power_consumption.txt")
electricity <- fread("dataset\\household_power_consumption.txt", sep = ";", na.strings = "?")

## Change global_active_power to not print in scientific notation
## modify in place using example from https://r-statistics.co/base-lapply-in-R.html
column_modify1 <- c("Global_active_power")
electricity[,(column_modify1) := lapply(.SD, as.numeric), .SDcols = column_modify1]

electricity[, DateTime := paste(Date,Time)]
electricity[, DateTime := as.POSIXct(DateTime,format="%d/%m/%Y %H:%M:%S")]
electricity[, DayWeek := as.factor(weekdays(DateTime, abbreviate = TRUE))]

electricity2 <- electricity[(DateTime >= "2007-02-01") & (DateTime <= "2007-02-03")]

png("plot4.png",width=480, height=480)
par(mfrow = c(2, 2))

plot(x=electricity2[,DateTime],y=electricity2[,Global_active_power], type = "l", xlab="", ylab="Global Active Power",xaxt = "n")
axis(1, at = electricity2[,DateTime], labels = electricity2[,DayWeek])

plot(x=electricity2[,DateTime],y=electricity2[,Voltage], type = "l", xlab="datetime", ylab="Voltage",xaxt = "n")
axis(1, at = electricity2[,DateTime], labels = electricity2[,DayWeek])

plot(x=electricity2[,DateTime],y=electricity2[,Sub_metering_1], type = "n", xlab="", ylab="Energy sub metering")
lines(x=electricity2[,DateTime],y=electricity2[,Sub_metering_1], type = "l", col = "Black")
lines(x=electricity2[,DateTime],y=electricity2[,Sub_metering_2], type = "l", col = "Red")
lines(x=electricity2[,DateTime],y=electricity2[,Sub_metering_3], type = "l", col = "Blue")
axis(1, at = electricity2[,DateTime], labels = electricity2[,DayWeek])
legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("Black","Red","Blue"), lwd=c(1,1),bty="n", cex=0.5)

plot(x=electricity2[,DateTime],y=electricity2[,Global_reactive_power], type = "l", xlab="datetime", ylab="Global_reactive_power",xaxt = "n")
axis(1, at = electricity2[,DateTime], labels = electricity2[,DayWeek])

dev.off()
