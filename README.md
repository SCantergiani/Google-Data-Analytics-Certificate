# Google Data Analytics Certificate Capstone Project

**Data Analyst:** Sebastián Cantergiani

**Client:** Cyclistic 

**Date:** February 2023


<br/>

# Introduction:
The Cyclistic case study  is a capstone project for Google Data Analytics Professional Course that will go through each step of the Data Analysis Process. Which are; ask, prepare, process, analyze, share and act. More details of the case study can be found [here](https://drive.google.com/file/d/1OviIa6kTO48-rZu8fvniFVScWMq2KSES/view?usp=sharing).

## Deliverables: 
1. A clear statement of the business task.
2. A description of all data sources used.
3. Documentation of any cleaning or manipulation of data.
4. A summary of the analysis.
5. Supporting visualizations and key findings.
6. Top three recommendations based on the analysis.

## Tools Used:
* Excel - check file integrity.
* SQL - for data preparation and processing.
* Power BI - for further analysis and data visualizations.
* PowerPoint - for data visualization presentations.
* Github- for store codes and changelogs into notebooks.

## Resources:
* Link to the presentation can be found [here](https://docs.google.com/presentation/d/11XoFu8RLbjXSOvPcGKejnESNxaD-otwVS699XTXTE48/edit?usp=sharing).
* Further detail on the dashboard can be seen [here](https://drive.google.com/drive/folders/1RkufrnRH9Nz_MM78vSggcP9WDupGBscI?usp=share_link).
* Data Analysis Process can be found [here](https://github.com/SCantergiani/Google-Data-Analytics-Certificate)

<br/>

# ASK

## Purpose: 
Cyclistics wants to maximize the number of annual memberships by converting casual riders into annual members.

## Key Stakeholders:  
* Director of marketing - Lily Moreno.
* Cyclistic marketing analytics team. 
* Cyclistic executive team.

## Business Task: 
* Examine how annual members and casual riders use Cyclistic bikes differently in the last 12 months.
* Why would casual riders buy Cyclistic annual memberships?
* How can Cyclistic use digital media to influence casual riders to become members?

## Scope of Work and Limitations: 
For the purpose of this case study we will only focus on Identifying differences between Cyclistic casual and members riders using bicycles in the past 12 months. 

<br/>

# PREPARE

## Data source: 
First hand data coming from Cyclistic cloud storage. This study used a monthly trip dataset from January 2022  to December 2022. More detail can be found here. 
The files were downloaded as CSV and stored locally in a folder using the file convention “YYYYMM divvy-tripdata.CSV”.

![file convention](https://i.ibb.co/Hrs79YF/fileconvention.png)

## Privacy:
Data-privacy issues prohibit using riders’ personally identifiable information. More detail can be found [here](https://ride.divvybikes.com/data-license-agreement).

## Data Integrity:
1. The files were inspected in Excel in order to check the data integrity, for consistency, accuracy and completeness. No duplicates were found and all files were consistent in their headings showing as follows: 
    * ride_id
    * rideable_type
    * started_at
    * ended_at
    * start_station_name
    * start_station_id
    * end_station_name
    * end_station_id
    * start_lat
    * start_lng
    * end_lat
    * end_lng
    * member_casual

However after applying filters to the data, the completeness in start and end stations may be compromised due to missed information. This can lead to sample bias and will be further investigated in the process phase.*

2. Once inspected in Excel, each file was uploaded to a new BigQuery database named “cyclistic_data”.


3. Added new columns:
* ride_length : calculated minutes between ended_at and started_at with “DATE_DIFF” function.
* day_of_week: extract the number of the week for the started_at date with “EXTRACT” function.

4. Merge the datasets addressing duplicates with the DISTINCT and UNION DISTINCT.

5. Saved the query in a new view called "2022_tripdata" containing the following code:

<br/>

## Transformation

<br/>

### Merge all tables and add columns ride_length and day_of_week 
```sql
SELECT
 DISTINCT *, 
 date_diff(ended_at,started_at,MINUTE) AS ride_length, 
 EXTRACT(DAYOFWEEK FROM started_at) AS  day_of_week
FROM
(SELECT * FROM `cyclistic_data.202201-divvy-tripdata` 
  UNION DISTINCT SELECT * FROM `cyclistic_data.202202-divvy-tripdata` 
  UNION DISTINCT SELECT * FROM `cyclistic_data.202203-divvy-tripdata`
  UNION DISTINCT SELECT * FROM `cyclistic_data.202204-divvy-tripdata`
  UNION DISTINCT SELECT * FROM `cyclistic_data.202205-divvy-tripdata`
  UNION DISTINCT SELECT * FROM `cyclistic_data.202206-divvy-tripdata`
  UNION DISTINCT SELECT * FROM `cyclistic_data.202207-divvy-tripdata`
  UNION DISTINCT SELECT * FROM `cyclistic_data.202208-divvy-tripdata`
  UNION DISTINCT SELECT * FROM `cyclistic_data.202209-divvy-tripdata`
  UNION DISTINCT SELECT * FROM `cyclistic_data.202210-divvy-tripdata`
  UNION DISTINCT SELECT * FROM `cyclistic_data.202211-divvy-tripdata`
  UNION DISTINCT SELECT * FROM `cyclistic_data.202212-divvy-tripdata`)
```
* We have 5436715 rows.

<br/>

# PROCESS

<br/>

## Data validation

<br/>

### Check Duplicates

```sql
SELECT
  DISTINCT COUNT(ride_id)
FROM
  `cyclistic_data.2022_tripdata`
```
* Row count did not change, that means there are no duplicates.

<br/>

### Check if there is NULL values

```sql
SELECT
  COUNT(*)
FROM
  `cyclistic_data.2022_tripdata`
WHERE (
  ride_id IS NULL
  OR rideable_type IS NULL
  OR started_at IS NULL
  OR ended_at IS NULL
  OR start_station_name IS NULL
  OR start_station_id IS NULL
  OR end_station_name IS NULL
  OR end_station_id IS NULL
  OR start_lat IS NULL
  OR start_lng IS NULL
  OR end_lat IS NULL
  OR end_lng IS NULL
  OR member_casual IS NULL
  OR ride_length IS NULL
  OR day_of_week IS NULL)
```
* 1067355 rows with at least one NULL cell.

<br/>

### Check for anomalies in the added columns ride_length
```sql
SELECT
  MIN(ride_length),MAX(ride_length),
FROM
  `cyclistic_data.2022_tripdata`
``` 

```sql
-- Check for anomalies in the added columns day_of_week.

SELECT
  DISTINCT(day_of_week),
FROM
  `cyclistic_data.2022_tripdata`
```
* No anomalies found.

<br/>

## Data cleaning

<br/>

### Removed rows with NULL cells
```sql
SELECT
  *
FROM
  `cyclistic_data.2022_tripdata`
WHERE NOT (
  ride_id IS NULL
  OR rideable_type IS NULL
  OR started_at IS NULL
  OR ended_at IS NULL
  OR start_station_name IS NULL
  OR start_station_id IS NULL
  OR end_station_name IS NULL
  OR end_station_id IS NULL
  OR start_lat IS NULL
  OR start_lng IS NULL
  OR end_lat IS NULL
  OR end_lng IS NULL
  OR member_casual IS NULL
  OR ride_length IS NULL
  OR day_of_week IS NULL)
```
* Rows went from 5436715 to 4369360. This represent over 20% of our data.

* A considerable amount of NULL values are coming from station_name and station_id, which represent around 20% of the size of the initial dataset. 
Proceeding with this step will imply a risk of missing important data for the analysis. That being said, we proceed to replace the NULL values instead to avoid sample bias.
In an ideal situation we would ask Cyclistic if this could mean that users also pick and drop bicycles on non-station points, or if this is related to a software issue.

<br/>

### Replaced NULL values, filtered ride_length dates below 0, trimmed all strings to ensure consistency and sorted the data
```sql
SELECT
  TRIM(ride_id) AS ride_id,
  TRIM(rideable_type) AS rideable_type,
  started_at,
  ended_at,
  ride_length,
  day_of_week,
  TRIM(COALESCE(start_station_name,"N/A")) AS start_station_name, -- Replace NULL values.
  TRIM(COALESCE(start_station_id,"N/A")) AS start_station_id,
  TRIM(COALESCE(end_station_name, "N/A")) AS end_station_name,
  TRIM(COALESCE(end_station_id, "N/A")) AS end_station_id,
  start_lat,
  start_lng,
  end_lat,
  end_lng,
  TRIM(member_casual) AS member_casual
FROM
  `cyclistic_data.2022_tripdata`
WHERE
  ride_length > 0
ORDER BY started_at ASC
```
* Row count at this point is 5328012.
* This will be our cleaned SQL table for further analysis.
* Saved the the cleaned data as a view called ‘202202_tripdata_cleaned’

<br/>

# ANALYZE PHASE

<br/>

### Calculate mean and max of ride_length
```sql
SELECT
  AVG(ride_length) AS avg_ride_length, 
  MAX(ride_length) AS max_ride_length
FROM
  `cyclistic_data.202202_tripdata_cleaned`
WHERE
  ride_length > 0
```
* Results:

| AVG | MAX |
| ----|------- |
| 19.2058 | 41387 |

<br/>

### Calculate total rides, max and avgerage ride length by type of user
```sql
SELECT
  member_casual,COUNT(*) AS num_of_rides,
  AVG(ride_length) AS avg_ride_length, 
  MAX(ride_length) AS max_ride_length
FROM
  `cyclistic_data.202202_tripdata_cleaned`
WHERE
  ride_length > 0
GROUP BY
  member_casual
```

* Results: 

| member_casual | num_of_rides | avg_ride_length |max_ride_length|
|---------------|--------------|-----------------|---------------|
| member        |  3143445     | 12.5638         | 1559          |
| casual        |  2184567     | 28.7632         | 41387         |

* Members rotate faster, although casual riders have more than double ride durations on average.

<br/>

### Weekday mode
```sql
SELECT
  APPROX_TOP_COUNT(day_of_week, 7) AS day_mode -- 7 represent the number of values to bring the mode.
FROM
  `cyclistic_data.202202_tripdata_cleaned`
WHERE
  ride_length > 0 
```

* Results: 

|Day Nº | Count |
|-------|-------|
|  7   | 861084 |
|  5   | 792110 |
|  4   | 755137 |
|  6   | 754496 |
|  3   | 734095 |
|  1   | 728420 |
|  2   | 702670 |

* Saturday is the most frequent day for bike riding.

<br/>

### Day mode by type of user
```sql
SELECT
  member_casual, 
  APPROX_TOP_COUNT(day_of_week, 1) AS day_mode
FROM
  `cyclistic_data.202202_tripdata_cleaned`
WHERE
  ride_length > 0
GROUP BY 
  member_casual
```
* Results: 

|member_casual | day_mode | count_day_mode|
|--------------|----------|---------------|
|    casual    |   7      | 446447        |
|    member    |   5      | 501335        |

*Week numbers Sunday = 1 and Saturday 7.*

* Rotation for casual riders is higher on Saturdays over any other day meanwhile members rotate more on thursdays.

<br/>

### Average ride length by day of week
```sql
SELECT
   day_of_week, 
   avg(ride_length) AS avg_ride_length
FROM
  `cyclistic_data.202202_tripdata_cleaned`
GROUP BY day_of_week
ORDER BY avg(ride_length) DESC
```

* Results:

|day_of_week | avg_ride_length |
|        1   |  23.9135086     |
|        7   |  23.4546722     |
|        6   |  18.7637588     |
|        2   |  18.1948055     |
|        5   |  16.8689866     |
|        3   |  16.4938298     |
|        4   |  16.2901142     |

*Week numbers Sunday = 1 and Saturday 7*

* On average rides are longer Saturdays and Sundays for both casual and member riders.

<br/>

### Bike preference by type of user
```sql
SELECT
   member_casual, 
   rideable_type, 
   count(rideable_type) AS count_rideable_type
FROM
  `cyclistic_data.202202_tripdata_cleaned`
GROUP BY member_casual, rideable_type
ORDER BY count(rideable_type) DESC
```

* Results:

|          member_casual | rideable_type | count_rideable_type|
|------------------------|---------------|--------------------|
|          member        | classic_bike  | 1685694|
|          member        | electric_bike | 1457751|
|          casual        | electric_bike | 1129727|
|          casual        | classic_bike  | 879193|
|          casual        | docked_bike   | 175647|

* From the analysis we can observe that members use more classic bikes while casual riders prefer electric bikes. 
On the other hand docked bikes have only been used by non member users in the last 12 months.


<br/>

Further Analysis was done using Microsoft Power BI.
