-- Merge all tables and add columns ride_length and day_of_week 

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

-- Note: we have 5436715 rows --

*Data validation*

-- Check Duplicates

SELECT
  DISTINCT COUNT(ride_id)
FROM
  `cyclistic_data.2022_tripdata`


Row count did not change, that means there are no duplicates.

Check if there is NULL values:
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
