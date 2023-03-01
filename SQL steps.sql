-- Merge all tables and add columns ride_length and day_of_week --

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