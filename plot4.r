#prepping for file download
temp <- tempfile()
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#download file
download.file (fileURL,temp, method="curl")

#load text file into a data table
data <- read.table(unz(temp, "household_power_consumption.txt"), sep=";", header=TRUE, stringsAsFactors = FALSE)
#Convert "?" characters into NA
data[data=="?"] = NA
#Convert the Date column as class Date
data$Date <- as.Date(data$Date, "%d/%m/%Y")

# subset data to required dates (2007-02-01 and 2007-02-02)
subdata <- subset(data, as.Date(Date) >= '2007-02-01' & as.Date(Date) <= '2007-02-02')

#merge the Date and Time columns into one Date Time Column
subdata$dateTime <- do.call(paste, c(subdata[c("Date", "Time")], sep=" "))
#convert the new DateTime Column as class POSIXlt
subdata$dateTime <- strptime(subdata$dateTime, "%Y-%m-%d %H:%M:%S")

#convert the global active power data to number
subdata$Global_active_power <- as.numeric(subdata$Global_active_power)

#Plot graphs and save results in PNG file (plot4.png) located in the working directory
png(file = "plot4.png")
par(mfrow = c(2,2))

#plot1
plot(subdata$dateTime, subdata$Global_active_power, type="l", ylab="Global Active Power", xlab="")
#plot2
plot(subdata$dateTime, subdata$Voltage, type="l", ylab="Voltage", xlab="datetime")
#plot3
plot(subdata$dateTime, subdata$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(subdata$dateTime, subdata$Sub_metering_2, col="red")
lines(subdata$dateTime, subdata$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), lty= c(1,1), lwd=c(2.5,2.5),col=c("black","red", "blue"), bty="n")
#plot#4
plot(subdata$dateTime, subdata$Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime")

dev.off()


unlink(temp)

