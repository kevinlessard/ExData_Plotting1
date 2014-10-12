
#load text file into a data table
data <- read.table("./household_power_consumption.txt", sep = ";", header = TRUE, stringsAsFactors = FALSE)
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

#Plot line and save results in PNG file (plot2.png) located in the working directory
png(file = "plot2.png")
plot(subdata$dateTime, subdata$Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="")
dev.off()




