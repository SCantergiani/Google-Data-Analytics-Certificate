# PROCESS PHASE 


--  Merge all tables and add columns ride_length and day_of_week.

SELECT
 DISTINCT *, date_diff(ended_at,started_at,MINUTE) AS ride_length, EXTRACT(DAYOFWEEK FROM started_at) AS  day_of_week
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

-- Note: we have 5436715 rows.

----------------------------------------------------------------------

## Data validation

-- Check Duplicates.

SELECT
  DISTINCT COUNT(ride_id)
FROM
  `cyclistic_data.2022_tripdata`

-- Row count did not change, that means there are no duplicates.

----------------------------------------------------------------------

-- Check if there is NULL values.

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

-- 1067355 rows with at least one NULL cell.

----------------------------------------------------------------------

-- Check for anomalies in the added columns ride_length.

SELECT
  MIN(ride_length),MAX(ride_length),
FROM
  `cyclistic_data.2022_tripdata`
 
----------------------------------------------------------------------

-- Check for anomalies in the added columns day_of_week.

SELECT
  DISTINCT(day_of_week),
FROM
  `cyclistic_data.2022_tripdata`

-- No anomalies found.

----------------------------------------------------------------------

## Data cleaning

-- Removed rows with NULL cells.

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

-- Note: rows went from 5436715 to 4369360. This represent over 20% of our data.

/* A considerable amount of NULL values are coming from station_name and station_id, which represent around 20% of the size of the initial dataset. 
Proceeding with this step will imply a risk of missing important data for the analysis. That being said, we proceed to replace the NULL values instead to avoid sample bias.
In an ideal situation we would ask Cyclistic if this could mean that users also pick and drop bicycles on non-station points, or if this is related to a software issue. */

----------------------------------------------------------------------

-- Replaced NULL values, filtered ride_length dates below 0, trimmed all strings to ensure consistency and sorted the data.

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

-- Row count at this point is 5328012.
-- This will be our cleaned SQL table for further analysis.

/* Saved the the cleaned data as a view called ‘202202_tripdata_cleaned’ */

----------------------------------------------------------------------

# ANALYZE PHASE

-- Calculated mean and max of ride_length. Also inspect the mode of day_of_week.

SELECT
  AVG(ride_length) AS avg_ride_length, MAX(ride_length) AS max_ride_length
FROM
  `cyclistic_data.202202_tripdata_cleaned`
WHERE
  ride_length > 0

-- Results: 
--AVG: 19.2058585
--MAX: 41387

----------------------------------------------------------------------

-- Ride_id count, avg_ride_length, max_ride_length by segment.

SELECT
  member_casual,COUNT(*) AS num_of_rides,AVG(ride_length) AS avg_ride_length, MAX(ride_length) AS max_ride_length
FROM
  `cyclistic_data.202202_tripdata_cleaned`
WHERE
  ride_length > 0
GROUP BY
  member_casual
--Results: member_casual | num_of_rides | avg_ride_length |max_ride_length
--         member        |  3143445     | 12.5638         | 1559
--         casual        |  2184567     | 28.7632         | 41387

/*Members rotate faster, although casual riders have more than double ride durations on average.*/


----------------------------------------------------------------------

-- Day_mode

SELECT
  APPROX_TOP_COUNT(day_of_week, 7) AS day_mode -- 7 represent the number of values to bring the mode.
FROM
  `cyclistic_data.202202_tripdata_cleaned`
WHERE
  ride_length > 0 
  
  -- Results: 
  --Day Nº | Count
  --   7   | 861084
  --   5   | 792110
  --   4   | 755137
  --   6   | 754496
  --   3   | 734095
  --   1   | 728420
  --   2   | 702670

	/*Saturday is the most frequent day for bike riding.*/
 
 ----------------------------------------------------------------------
 
-- Day_mode by type of user.

SELECT
  member_casual, APPROX_TOP_COUNT(day_of_week, 1) AS day_mode
FROM
  `cyclistic_data.202202_tripdata_cleaned`
WHERE
  ride_length > 0
GROUP BY 
  member_casual

--Results: member_casual | day_mode | count_day_mode
--             casual    |   7      | 446447
--             member    |   5      | 501335

-- *Week numbers Sunday = 1 and Saturday 7.

/*Rotation for casual riders is higher on Saturdays over any other day meanwhile members rotate more on thursdays.*/
 
 ----------------------------------------------------------------------
 
-- Avg_ride by day_of_week.

SELECT
   day_of_week, avg(ride_length) AS avg_ride_length
FROM
  `cyclistic_data.202202_tripdata_cleaned`
GROUP BY day_of_week
ORDER BY avg(ride_length) DESC

-- Results: day_of_week | avg_ride_length |
--                  1   |  23.9135086     |
--                  7   |  23.4546722     |
--                  6   |  18.7637588     |
--                  2   |  18.1948055     |
--                  5   |  16.8689866     |
--                  3   |  16.4938298     |
--                  4   |  16.2901142     |

-- *Week numbers Sunday = 1 and Saturday 7.

/* On average rides are longer Saturdays and Sundays for both casual and member riders.*/

 ----------------------------------------------------------------------

-- Rideable_type by type of user.

SELECT
   member_casual, rideable_type, count(rideable_type) AS count_rideable_type
FROM
  `cyclistic_data.202202_tripdata_cleaned`
GROUP BY member_casual, rideable_type
ORDER BY count(rideable_type) DESC

-- Results: member_casual | rideable_type | count_rideable_type
--          member        | classic_bike  | 1685694
--          member        | electric_bike | 1457751
--          casual        | electric_bike | 1129727
--          casual        | classic_bike  | 879193
--          casual        | docked_bike   | 175647

/* From the analysis we can observe that members use more classic bikes while casual riders prefer electric bikes. 
On the other hand docked bikes have only been used by non member users in the last 12 months.*/

 ----------------------------------------------------------------------
 
 Further Analysis was done using Microsoft Power BI.

