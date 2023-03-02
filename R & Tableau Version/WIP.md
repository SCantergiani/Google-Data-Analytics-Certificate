#Capstone Project Google Data Analytics Certificate

## Install Packages

install.packages("tidyverse") 
install.packages("lubridate")
install.packages("ggplot2")

## Load Packages

library(tidyverse)
library(lubridate)
library(ggplot2)

## Step 1) Collect data

Month_202201 <- read.csv("202201-divvy-tripdata.csv")
Month_202202 <- read.csv("202202-divvy-tripdata.csv")
Month_202203 <- read.csv("202203-divvy-tripdata.csv")
Month_202204 <- read.csv("202204-divvy-tripdata.csv")
Month_202205 <- read.csv("202205-divvy-tripdata.csv")
Month_202206 <- read.csv("202206-divvy-tripdata.csv")
Month_202207 <- read.csv("202207-divvy-tripdata.csv")
Month_202208 <- read.csv("202208-divvy-tripdata.csv")
Month_202209 <- read.csv("202209-divvy-tripdata.csv")
Month_202210 <- read.csv("202210-divvy-tripdata.csv")
Month_202211 <- read.csv("202211-divvy-tripdata.csv")
Month_202212 <- read.csv("202212-divvy-tripdata.csv")

## Step 2) Weangle data and comine into single file

### Checking if col matches.

colnames(Month_202201)
colnames(Month_202202)
colnames(Month_202203)
colnames(Month_202204)
colnames(Month_202205)
colnames(Month_202206)
colnames(Month_202207)
colnames(Month_202208)
colnames(Month_202209)
colnames(Month_202210)
colnames(Month_202211)
colnames(Month_202212)

### Inspect dataframe for incongruences

str(Month_202201)
str(Month_202202)
str(Month_202203)
str(Month_202204)
str(Month_202205)
str(Month_202206)
str(Month_202207)
str(Month_202208)
str(Month_202209)
str(Month_202210)
str(Month_202211)
str(Month_202212)

### Combine files

alltrips <- bind_rows(Month_202201,
                      Month_202202,
                      Month_202203,
                      Month_202204,
                      Month_202205,
                      Month_202206,
                      Month_202207,
                      Month_202208,
                      Month_202209,
                      Month_202210,
                      Month_202211,
                      Month_202212)

### Dropping start_lat, start_lng, end_lat, end_lng

alltrips <- alltrips %>% 
  select(-c(start_lat ,start_lng ,end_lat,end_lng))

STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS

### Inspect the new table

colnames(alltrips) #List of column names
nrow(alltrips) #Number of rows
dim(alltrips) #Dimensions of the data frame
head(alltrips) #6 first rows of the data frame
tail(alltrips) #6 last rows of the data frame
str(alltrips) # List of columns and data types
summary(alltrips) #statistical summary of data

### Seeing how many observations fall under each usertype
table(alltrips$member_casual)


### We will want to add some additional columns of data -- such as day, month, year -- that provide additional opportunities to aggregate the data.

alltrips$date <- as.Date(alltrips$started_at)
alltrips$month <- format(as.Date(alltrips$date), "%m")
alltrips$day <- format(as.Date(alltrips$date), "%d")
alltrips$year <- format(as.Date(alltrips$date), "%Y")
alltrips$day_of_week <- format(as.Date(alltrips$date), "%A")


### We will want to add a calculated field for length of ride in seconds. We will add "ride_length" to the entire data frame for consistency. We must convert from string to numeric.

## First we need to format to datetime started_at and ended_at.

alltrips$ended_at <- as_datetime(alltrips$ended_at)
alltrips$started_at <- as_datetime(alltrips$started_at)

## Add a "ride_length" calculation to all_trips (in seconds)

alltrips$ride_length <- difftime(alltrips$ended_at,alltrips$started_at)

### Inspect the structure of the columns

str(alltrips)

# Convert "ride_length" from Factor to numeric so we can run calculations on the data

alltrips$ride_length <- as.numeric(alltrips$ride_length)



### There are some rides where trip duration shows up as negative, including several hundred rides where Divvy took bikes out of circulation for Quality Control reasons. We will want to delete these rides.

# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative
# We will create a new version of the dataframe (v2) since data is being removed

alltrips_v2 <- alltrips[!(alltrips$ride_length<0),]

# Dropping NA's

alltrips_v2 <-  alltrips_v2 %>% drop_na(ride_length)

# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS

mean(alltrips_v2$ride_length) ## Mean   :   1162 
median(alltrips_v2$ride_length) ## Median : 612
max(alltrips_v2$ride_length) ## Max : 2483235
min(alltrips_v2$ride_length) ## Min : 0

# Condensating all of above

summary(alltrips_v2$ride_length) #Min. 1st Qu.  Median    Mean 3rd Qu.    Max.  
                                 #   0     348     612    1162    1091 2483235  

#Grouping by user type

aggregate(alltrips_v2$ride_length ~ alltrips_v2$member_casual, FUN = mean)
#  alltrips_v2$member_casual alltrips_v2$ride_length
#                     casual               1732.0661
#                    member                764.3209
aggregate(alltrips_v2$ride_length ~ alltrips_v2$member_casual, FUN = median)
#alltrips_v2$member_casual alltrips_v2$ride_length
#                    casual                     759
#                    member                     531
aggregate(alltrips_v2$ride_length ~ alltrips_v2$member_casual, FUN = max)
#alltrips_v2$member_casual alltrips_v2$ride_length
#                    casual                 2483235
#                    member                   93594
aggregate(alltrips_v2$ride_length ~ alltrips_v2$member_casual, FUN = min)
#alltrips_v2$member_casual alltrips_v2$ride_length
#                    casual                       0
#                    member                       0

# See the average ride time by each day for members vs casual users
aggregate(alltrips_v2$ride_length ~ alltrips_v2$member_casual + alltrips_v2$day_of_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
alltrips_v2$day_of_week <- ordered(alltrips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(alltrips_v2$ride_length ~ alltrips_v2$member_casual + alltrips_v2$day_of_week, FUN = mean)

#alltrips_v2$member_casual alltrips_v2$day_of_week alltrips_v2$ride_length
#                     casual                  Sunday               2051.1224
#                     member                  Sunday                845.5366
#                     casual                  Monday               1708.9736
#                     member                  Monday                733.0285
#                     casual                 Tuesday               1538.3154
#                     member                 Tuesday                729.7465
#                     casual               Wednesday               1487.6948
#                     member               Wednesday                731.8071
#                     casual                Thursday               1502.9232
#                    member                Thursday                736.1867
#                    casual                  Friday               1679.7340
#                    member                  Friday                758.6397
#                    casual                Saturday               1938.2607
#                    member                Saturday                847.6645

# Analyze ridership data by type and weekday

alltrips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n() #calculates the number of rides and average duration
  ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)	

# member_casual weekday number_of_rides average_duration
# <chr>         <ord>             <int>            <dbl>
#  casual        Sun              314302            2051.
# casual        Mon              218140            1709.
# casual        Tue              214114            1538.
# casual        Wed              239831            1488.
# casual        Thu              259149            1503.
# casual        Fri              285610            1680.
# casual        Sat              384000            1938.
# member        Sun              312977             846.
# member        Mon              377343             733.
# member        Tue              418643             730.
# member        Wed              446383             732.
# member        Thu              441997             736.
# member        Fri              388810             759.
# member        Sat              360212             848.

# Let's visualize the number of rides by rider type
alltrips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration
alltrips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

#export CSV

write.csv(alltrips_v2,file = "C:/Users/Seb/Documents/R_dataframe.csv")

