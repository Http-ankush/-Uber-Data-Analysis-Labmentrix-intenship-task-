create database labmentrix
 
 use labmentrix;
 
/*created the Table */ 


SHOW VARIABLES LIKE 'secure_file_priv';


SET GLOBAL local_infile=1;


/*Created the table trips cleaned*/
CREATE TABLE trips_cleaned (
    request_id INT,
    pickup_point VARCHAR(50),
    driver_id VARCHAR(20),  -- CHANGED from INT to VARCHAR
    status VARCHAR(50),
    request_timestamp VARCHAR(50),
    drop_timestamp VARCHAR(50)
);


/* loaded the data */
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trips_cleaned.csv'
INTO TABLE trips_cleaned
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


ALTER TABLE trips_cleaned
ADD COLUMN request_time DATETIME,
ADD COLUMN drop_time DATETIME;

/* Counting the total trips and got '6745' tottal trips
 */
SELECT COUNT(*) AS total_trips FROM trips_cleaned;

/* Count of trips by status*/
SELECT status, COUNT(*) AS trip_count
FROM trips_cleaned
GROUP BY status
ORDER BY trip_count DESC;
/*Trip Completed	2831
No Cars Available	2650
Cancelled	1264*/

/* Trips by pickup point and status */
SELECT pickup_point, status, COUNT(*) AS trip_count
FROM trips_cleaned
GROUP BY pickup_point, status
ORDER BY pickup_point, trip_count DESC;
/*Trip Completed	2831
No Cars Available	2650
Cancelled	1264*/

/*ID Requested By hours*/
SELECT HOUR(request_time) AS hour_of_day, COUNT(*) AS total_requests
FROM trips_cleaned
GROUP BY hour_of_day
ORDER BY total_requests DESC;
/* Total Request  '6745'*/

/*Driver Assignment Issues – Unassigned Requests*/
SELECT COUNT(*) AS unassigned_trips
FROM trips_cleaned
WHERE driver_id = 'NA';
/* here we have 2650 unassigned trips */

/* Completion Rate*/
SELECT 
  ROUND(SUM(CASE WHEN status = 'Trip Completed' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS completion_rate_percentage
FROM trips_cleaned;
/* here we find the completion rate as 41.97 % */











