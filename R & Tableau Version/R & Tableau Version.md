# Google Data Analytics Certificate Capstone Project

## R & Tableau version

<br/>

**Data Analyst:** Sebastián Cantergiani

**Client:** Cyclistic

**Date:** February 2023

<br/>

### Context

The Cyclistic case study is a capstone project for Google Data Analytics
Professional Course that will go through each step of the Data Analysis
Process. Which are:

- [Ask](https://github.com/SCantergiani/Google-Data-Analytics-Certificate/blob/main/R%20&%20Tableau%20Version/R%20&%20Tableau%20Version.md#ask)
- [Prepare](https://github.com/SCantergiani/Google-Data-Analytics-Certificate/blob/main/R%20&%20Tableau%20Version/R%20&%20Tableau%20Version.md#prepare)
- [Process](https://github.com/SCantergiani/Google-Data-Analytics-Certificate/blob/main/R%20&%20Tableau%20Version/R%20&%20Tableau%20Version.md#process)
- [Analyze](https://github.com/SCantergiani/Google-Data-Analytics-Certificate/blob/main/R%20&%20Tableau%20Version/R%20&%20Tableau%20Version.md#analyze)
- [Share](https://github.com/SCantergiani/Google-Data-Analytics-Certificate/blob/main/R%20&%20Tableau%20Version/R%20&%20Tableau%20Version.md#share)
- [Act](https://github.com/SCantergiani/Google-Data-Analytics-Certificate/blob/main/R%20&%20Tableau%20Version/R%20&%20Tableau%20Version.md#act)

### Deliverables

1.  A clear statement of the business task.
2.  A description of all data sources used.
3.  Documentation of any cleaning or manipulation of data.
4.  A summary of the analysis.
5.  Supporting visualizations and key findings.
6.  Top three recommendations based on the analysis.

### Tools Used

- Excel - check file integrity.
- SQL - BigQuery for data preparation and processing.
- Power BI - for further analysis and data visualizations.
- PowerPoint - for data visualization presentations.
- Github- for store codes and changelogs into notebooks.

### Resources

- Link to the presentation can be found
  [here](https://docs.google.com/presentation/d/11XoFu8RLbjXSOvPcGKejnESNxaD-otwVS699XTXTE48/edit?usp=sharing).
- The dashboard can seen
  [here](https://public.tableau.com/views/Cyclistic_16778151668290/Dashboard?:language=en-US&:display_count=n&:origin=viz_share_link).
- Details of the case study can be found
  [here](https://drive.google.com/file/d/1OviIa6kTO48-rZu8fvniFVScWMq2KSES/view?usp=sharing).
- SQL & Power BI version of this analysis can be found
  [here](https://github.com/SCantergiani/Google-Data-Analytics-Certificate#google-data-analytics-certificate-capstone-project).

<br/>

------------------------------------------------------------------------

## ASK

### Purpose

Cyclistics wants to maximize the number of annual memberships by
converting casual riders into annual members.

### Key Stakeholders

- Director of marketing - Lily Moreno.
- Cyclistic marketing analytics team.
- Cyclistic executive team.

### Business Task

- Examine how annual members and casual riders use Cyclistic bikes
  differently in the last 12 months.
- Why would casual riders buy Cyclistic annual memberships?
- How can Cyclistic use digital media to influence casual riders to
  become members?

### Scope of Work and Limitations

For the purpose of this case study we will only focus on Identifying
differences between Cyclistic casual and members riders using bicycles
in the past 12 months.

<br/>

------------------------------------------------------------------------

## PREPARE

### Data source

First hand data coming from Cyclistic cloud storage. This study used a
monthly trip dataset from January 2022 to December 2022. More detail can
be found here. The files were downloaded as CSV and stored locally in a
folder using the file convention “YYYYMM divvy-tripdata.CSV”.

![file convention](https://i.ibb.co/Hrs79YF/fileconvention.png)

### Privacy

Data-privacy issues prohibit using riders’ personally identifiable
information. More detail can be found
[here](https://ride.divvybikes.com/data-license-agreement).

### Data Integrity

1.  The files were inspected in Excel in order to check the data
    integrity, for consistency, accuracy and completeness. No duplicates
    were found and all files were consistent in their headings showing
    as follows:

    - ride_id
    - rideable_type
    - started_at
    - ended_at
    - start_station_name
    - start_station_id
    - end_station_name
    - end_station_id
    - start_lat
    - start_lng
    - end_lat
    - end_lng
    - member_casual

    After applying filters to the data, the completeness in start and
    end stations may be compromised due to missed information. This can
    lead to sample bias and will be further investigated in the process
    phase.

2.  Once inspected in Excel, each file was uploaded to RStudio.

### Transformation in RStudio

**Load Packages**

``` r
library(tidyverse)
library(lubridate)
library(ggplot2)
library(skimr)
```

<br/>

**Importing files into R**

``` r
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
```

<br/>

**Before we merge them we must check for consistency in columns type and
name**

``` r
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
```

<br/>

``` r
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
```

- The format of starting_at and ending_at for the months April and May
  doesn’t include seconds. We must fix this in order to proceed or it
  will lead to errors later.

<br/>

**Adding a “seconds” value to the string”**

``` r
Month_202204$started_at <- paste(Month_202204$started_at,":00")
Month_202204$ended_at <- paste(Month_202204$ended_at,":00")
Month_202205$started_at <- paste(Month_202205$started_at,":00")
Month_202205$ended_at <- paste(Month_202205$ended_at,":00")
```

<br/>

**Combine files with bind_rows function and store it a new data frame
called “alltrips”**

``` r
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
```

<br/>

**Deleting columns start_lat, start_lng, end_lat and end_lng**

``` r
alltrips <- alltrips %>% 
  select(-c(start_lat ,start_lng ,end_lat ,end_lng)) # Select and remove columns with "-c".
```

<br/>

------------------------------------------------------------------------

## PROCESS

Clean up and add data to prepare for analysis

### Inspecting the new table

<br/>

``` r
skim_without_charts(alltrips) # Quickly providing a broad overview of a data frame
```

|                                                  |          |
|:-------------------------------------------------|:---------|
| Name                                             | alltrips |
| Number of rows                                   | 5436715  |
| Number of columns                                | 9        |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |          |
| Column type frequency:                           |          |
| character                                        | 9        |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |          |
| Group variables                                  | None     |

Data summary

**Variable type: character**

| skim_variable      | n_missing | complete_rate | min | max |  empty | n_unique | whitespace |
|:-------------------|----------:|--------------:|----:|----:|-------:|---------:|-----------:|
| ride_id            |         0 |             1 |   7 |  16 |      0 |  5436715 |          0 |
| rideable_type      |         0 |             1 |  11 |  13 |      0 |        3 |          0 |
| started_at         |         0 |             1 |  19 |  20 |      0 |  3972013 |          0 |
| ended_at           |         0 |             1 |  19 |  20 |      0 |  3982271 |          0 |
| start_station_name |         0 |             1 |   0 |  64 | 675473 |     1671 |          0 |
| start_station_id   |         0 |             1 |   0 |  44 | 675473 |     1338 |          0 |
| end_station_name   |         0 |             1 |   0 |  64 | 724283 |     1685 |          0 |
| end_station_id     |         0 |             1 |   0 |  44 | 724283 |     1339 |          0 |
| member_casual      |         0 |             1 |   6 |   6 |      0 |        2 |          0 |

``` r
summary(alltrips) #statistical summary of data
```

    ##    ride_id          rideable_type       started_at          ended_at        
    ##  Length:5436715     Length:5436715     Length:5436715     Length:5436715    
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##  start_station_name start_station_id   end_station_name   end_station_id    
    ##  Length:5436715     Length:5436715     Length:5436715     Length:5436715    
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##  member_casual     
    ##  Length:5436715    
    ##  Class :character  
    ##  Mode  :character

<br/>

**Seeing how many observations fall under each user type**

``` r
table(alltrips$member_casual)
```

    ## 
    ##  casual  member 
    ## 2227343 3209372

<br/>

**We will want to add some additional columns of data such as day,
month, year. That will provide additional opportunities to aggregate the
data**

``` r
alltrips$date <- as.Date(alltrips$started_at)
alltrips$month <- format(as.Date(alltrips$date), "%m") #Extract Month
alltrips$day <- format(as.Date(alltrips$date), "%d") #Extract Day
alltrips$year <- format(as.Date(alltrips$date), "%Y") #Extract Year
alltrips$day_of_week <- format(as.Date(alltrips$date), "%A") #Extract day of week
```

<br/>

**Forcing format to datetime started_at and ended_at**

``` r
alltrips$ended_at <- as_datetime(alltrips$ended_at)
alltrips$started_at <- as_datetime(alltrips$started_at)
```

<br/>

**Add a “ride_length” calculation to all_trips (in seconds)**

``` r
alltrips$ride_length <- difftime(alltrips$ended_at,alltrips$started_at, units = "mins")
```

<br/>

**Inspect the structure of the columns**

``` r
str(alltrips)
```

<br/>

**Convert “ride_length” to numeric so we can run calculations on the
data**

``` r
alltrips$ride_length <- as.numeric(alltrips$ride_length)
```

<br/>

**There are some rides where trip duration shows up as negative,
including several hundred rides where Cyclistic took bikes out of
circulation for Quality Control reasons. We will want to delete these
rides and create a new version of the data frame (v2)**

``` r
alltrips_v2 <- alltrips[!(alltrips$ride_length<0),]
```

<br/>

------------------------------------------------------------------------

## ANALYZE

<br/>

**Calculating avg, median, max and min**

``` r
summary(alltrips_v2$ride_length) 
```

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ##     0.00     5.92    10.30    19.24    18.52 41387.25

<br/>

**Grouping by user type**

``` r
alltrips_v2 %>% 
  group_by(member_casual) %>% 
  summarize(mean(ride_length), median(ride_length), max(ride_length), min(ride_length))
```

    ## # A tibble: 2 × 5
    ##   member_casual `mean(ride_length)` `median(ride_length)` max(ride_len…¹ min(r…²
    ##   <chr>                       <dbl>                 <dbl>          <dbl>   <dbl>
    ## 1 casual                       28.6                 13            41387.       0
    ## 2 member                       12.7                  8.95          1560.       0
    ## # … with abbreviated variable names ¹​`max(ride_length)`, ²​`min(ride_length)`

<br/>

**See the average ride time by each day for members vs casual users**

``` r
alltrips_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarize(mean(ride_length))
```

    ## # A tibble: 14 × 3
    ## # Groups:   member_casual [2]
    ##    member_casual day_of_week `mean(ride_length)`
    ##    <chr>         <chr>                     <dbl>
    ##  1 casual        Friday                     27.5
    ##  2 casual        Monday                     28.5
    ##  3 casual        Saturday                   32.0
    ##  4 casual        Sunday                     33.5
    ##  5 casual        Thursday                   25.0
    ##  6 casual        Tuesday                    25.4
    ##  7 casual        Wednesday                  24.6
    ##  8 member        Friday                     12.6
    ##  9 member        Monday                     12.3
    ## 10 member        Saturday                   14.2
    ## 11 member        Sunday                     14.1
    ## 12 member        Thursday                   12.3
    ## 13 member        Tuesday                    12.1
    ## 14 member        Wednesday                  12.1

<br/>

**For a better visualization we proceed to order the days labels**

``` r
alltrips_v2$day_of_week <- ordered(alltrips_v2$day_of_week, levels=c("Sunday", "Monday", 
"Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
```

<br/>

**Analyze avg duration and number of rides data by type and weekday**

``` r
table_1 <- alltrips_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarize(number_of_rides = n(), avg_duration = mean(ride_length)) %>% # Calculates the number of rides and average duration
  arrange(member_casual) # Order by member_casual ASC
```

<br/>

**Visualize avg duration and number of rides data by type and weekday**

``` r
ggplot(data = table_1, aes(x = day_of_week, y = number_of_rides, fill=member_casual))+
  geom_col(position = "dodge")+ # Dodge separte segments in different columns
  labs(title = "Number of rides by type of user") # Added title
```

![](https://i.ibb.co/bKQvsjY/image.png)<!-- -->

<br/>

**Visualization for average duration**

``` r
ggplot(data = table_1, aes(x = day_of_week, y = avg_duration, fill=member_casual))+
  geom_col(position = "dodge")+
  labs(title = "Average duration by type of user")
```

![](https://i.ibb.co/3ScDgQb/image.png)<!-- --> <br/>

**We save the cleaned dataframe**

``` r
write.csv(alltrips_v2,file = "C:/Users/Seb/Documents/R_dataframe.csv")
```

------------------------------------------------------------------------

## SHARE

Once we understand our insights and know the key findings then we
proceed to export the cleaned dataset into Tableau and check we miss any
formats after loading our data:

![tableau1](https://i.ibb.co/7r966Dr/image.png)

### Dashboard

For the purpose of this project we will be making a dashboard and a presentation for our stakeholders. That being said we created
the following type of visualizations:

- Label - Shows total rides of 2022.
- Donough chart - Shows participation of total rides segmented by user
  type.
- Bar chart - Shows bike preference by user.
- Column charts:
  - Ride length by month - Indicates the total ride time in hours for
    each month by type of client.

  - Number of rides by month - Indicates how many times the service was
    used by type of client.

  - Number of rides by weekday - Shows the weekly rotation for Cyclistic
    bike rent services by user type.

### Meaning and refining

In order to ensure meaning and refining data visualization, the
following steps were applied:

1.  A title and a subtitle was added to add context to the analysis and
    indicate the scope of work.
2.  ‘Y- axis’ start point set to 0 for accurate proportions.
3.  Carefully choose a color palette, shape and size in order to
    contrast and draw the most important findings.

![dashboard](https://i.ibb.co/MBDJtn4/image.png)

The dashboard can be seen [here](https://public.tableau.com/views/Cyclistic_16778151668290/Dashboard?:language=en-US&:display_count=n&:origin=viz_share_link).

### Presentation

Later, all graphs that showed key finding were exported into Google
Slides to create the presentation. This steps were applied:

1.  Added an introduction slide with the name of the analysis and the
    year of study.
2.  Added context by introducing the objectives.
3.  Segmented the key findings and ordered them to show broad findings
    first then details.
4.  Added small entry effects in order to maintain focus on key
    elements.
5.  Added a small description of findings and a more detailed
    description in the speaker notes.
6.  Added appendix for more details.

Link to the presentation can be found [here](https://docs.google.com/presentation/d/11XoFu8RLbjXSOvPcGKejnESNxaD-otwVS699XTXTE48/edit?usp=sharing).

<br/>

------------------------------------------------------------------------

## ACT

### Conclusions

1.  Casual riders tend to ride longer and have extended sessions in the
    summer season.
2.  On average non-member clients ride longer than members.
3.  Weekends are preferred by casual riders.
4.  Electric bikes are picked more often by casual riders.

### Recommendations

From the analysis it can be inferred that casual riders differ in many
ways from member riders. That being said the top three recommendations
are:

1.  Seek for weekend member incentives such as discounts, free passes,
    and alliances.
2.  Free or discounted electric bike rides since casual riders prefer
    them.
3.  Adjust the business goal in order to create season passes and
    maximize summer and fall clients.

The marketing analytics team should focus on these insights related to
the business task, and find the way to drive the correct marketing
strategy in order to maximize the memberships.

### Expand findings

- The findings could be expanded searching for a correlation between
  tourist increase in summer season.
- Age and sex of users could have been a good option for an even more
  targeted marketing strategy.
