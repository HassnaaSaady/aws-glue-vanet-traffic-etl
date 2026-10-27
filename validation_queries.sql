
-- AWS Glue VANET Traffic ETL
-- Data validation queries for Amazon Athena
-- Update the database/table names if needed.

-- 1. Check total number of processed records
SELECT COUNT(*) AS total_records
FROM vanet_database.vanet_traffic_processed;


-- 2. Check for NULL values in important columns
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN "timestamp" IS NULL THEN 1 ELSE 0 END) AS null_timestamps,
    SUM(CASE WHEN avg_speed_kmph IS NULL THEN 1 ELSE 0 END) AS null_avg_speed,
    SUM(CASE WHEN density_veh_per_km IS NULL THEN 1 ELSE 0 END) AS null_density,
    SUM(CASE WHEN flow_veh_per_hr IS NULL THEN 1 ELSE 0 END) AS null_flow
FROM vanet_database.vanet_traffic_processed;


-- 3. Check for duplicate records
-- Replace the columns below with the actual unique record identifiers
-- if your dataset has a suitable key.
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT "timestamp") AS distinct_timestamps
FROM vanet_database.vanet_traffic_processed;


-- 4. Check for invalid negative traffic measurements
SELECT COUNT(*) AS invalid_numeric_records
FROM vanet_database.vanet_traffic_processed
WHERE
    (avg_speed_kmph < 0)
    OR (density_veh_per_km < 0)
    OR (flow_veh_per_hr < 0);


-- 5. Check percentage columns are within the expected range
SELECT COUNT(*) AS invalid_percentage_records
FROM vanet_database.vanet_traffic_processed
WHERE
    (occupancy_pct < 0 OR occupancy_pct > 100)
    OR (packet_loss_pct < 0 OR packet_loss_pct > 100);


-- 6. Preview processed records
SELECT *
FROM vanet_database.vanet_traffic_processed
LIMIT 10;
