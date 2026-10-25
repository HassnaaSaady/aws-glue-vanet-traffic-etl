# aws-glue-vanet-traffic-etl
# AWS Glue Visual ETL Pipeline for VANET Traffic Data

## Overview

This project demonstrates a cloud-based ETL pipeline for processing Vehicular Ad Hoc Network (VANET) traffic data using AWS services.

The pipeline reads raw traffic data in CSV format from Amazon S3, applies schema transformations and duplicate-record removal using AWS Glue Studio, writes processed data in Parquet format to Amazon S3, and makes the resulting dataset available for SQL analytics through Amazon Athena.

## Project Objectives

- Build a visual ETL workflow using AWS Glue Studio.
- Ingest traffic data stored in Amazon S3.
- Transform column data types into appropriate analytical types.
- Remove duplicate records.
- Store processed data in Parquet format.
- Register dataset metadata in the AWS Glue Data Catalog.
- Validate the processed dataset and query it using Amazon Athena.

## Architecture

```text
Raw CSV Dataset
      |
      v
Amazon S3 (Raw Layer)
      |
      v
AWS Glue Studio
  - S3 Source
  - Change Schema
  - Drop Duplicates
  - S3 Target
      |
      v
Amazon S3 (Processed Layer)
      |
      v
AWS Glue Data Catalog
      |
      v
Amazon Athena (SQL Analytics)
```

## Technology Stack

- **Amazon S3:** Stores raw and processed datasets.
- **AWS Glue Studio:** Builds and runs the visual ETL workflow.
- **AWS Glue Data Catalog:** Stores table metadata and schema information.
- **Amazon Athena:** Executes SQL queries against the processed data.
- **CSV:** Input data format.
- **Apache Parquet:** Processed columnar storage format.
- **Snappy compression:** Used if enabled in the final S3 target configuration.
- **SQL:** Data validation and analytical queries.

## Dataset

The input dataset contains 27 columns describing traffic conditions, road segments, environmental factors, and wireless communication metrics.

Example fields include:

- `timestamp`
- `road_segment_id`
- `avg_speed_kmph`
- `density_veh_per_km`
- `avg_wait_time_s`
- `occupancy_pct`
- `flow_veh_per_hr`
- `queue_length_veh`
- `temp_c`
- `visibility_km`
- `channel_busy_ratio_pct`
- `avg_comm_delay_ms`
- `packet_loss_pct`
- `label`

The `label` field represents the traffic category provided by the dataset.

## ETL Workflow

### 1. Data Ingestion

The pipeline reads the source CSV file from Amazon S3 using an AWS Glue Studio S3 source node.

### 2. Schema Transformation

The Change Schema transformation assigns appropriate data types to the dataset columns, including timestamp, numeric, and string fields.

Data type conversions are validated to ensure that valid source values are preserved in the processed output.

### 3. Duplicate Removal

The Drop Duplicates transformation removes duplicate records according to the configured deduplication criteria.

### 4. Data Storage

The S3 target writes the transformed dataset in Parquet format to the processed-data location.

Snappy compression is used when enabled in the target configuration.

### 5. Data Catalog Integration

The processed dataset is registered in the AWS Glue Data Catalog so that its schema and storage location can be referenced by analytical services.

### 6. SQL Analytics and Validation

Amazon Athena is used to inspect the processed data, check record counts, investigate null values, and validate the output schema.

## Example Athena Queries

Replace the database and table names if your AWS environment uses different names.

### Inspect the output

```sql
SELECT *
FROM vanet_database.vanet_traffic_processed
LIMIT 10;
```

### Count processed records

```sql
SELECT COUNT(*) AS total_rows
FROM vanet_database.vanet_traffic_processed;
```

### Check null values in important columns

```sql
SELECT
    COUNT(*) AS total_rows,
    COUNT(timestamp) AS non_null_timestamps,
    COUNT(road_segment_id) AS non_null_road_ids,
    COUNT(avg_speed_kmph) AS non_null_speeds,
    COUNT(label) AS non_null_labels
FROM vanet_database.vanet_traffic_processed;
```

### Check for duplicate records

```sql
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ROW(
        timestamp,
        road_segment_id,
        avg_speed_kmph,
        density_veh_per_km,
        label
    )) AS distinct_selected_combinations
FROM vanet_database.vanet_traffic_processed;
```

The last query checks distinct combinations of selected fields, not necessarily duplicates across all 27 columns. Adjust the fields to match the deduplication logic used in the pipeline.

## Data Validation Checklist

Before considering the pipeline complete, verify the following:

- [ ] The Glue job completes successfully.
- [ ] The expected Parquet files exist in the processed S3 location.
- [ ] The Data Catalog table points to the correct output location.
- [ ] Timestamp and numeric conversions preserve valid source values.
- [ ] Null values are checked and handled according to the dataset requirements.
- [ ] Duplicate removal behaves as expected.
- [ ] Athena queries return valid results.
- [ ] Data quality rules pass after any required fixes.

## Repository Structure

```text
aws-glue-vanet-traffic-etl/
├── README.md
├── docs/
│   ├── architecture.png
│   ├── glue-job-screenshot.png
│   └── athena-validation.png
└── sql/
    └── validation_queries.sql
```

## Learning Outcomes

This project provides practical experience with:

- Cloud-based data ingestion and storage.
- Visual ETL workflow design.
- Schema management and data type conversion.
- Duplicate-record removal and data validation.
- Columnar data storage using Parquet.
- AWS Glue Data Catalog integration.
- SQL-based data inspection using Amazon Athena.

## Notes

This repository documents the project workflow and validation approach. Screenshots, query outputs, and performance measurements should reflect the actual implementation.

No performance improvement or data-quality result is claimed unless it has been measured and verified.

## Author

**Hassnaa Saady**

GitHub: https://github.com/hassnaakharboush

LinkedIn: https://linkedin.com/in/HassnaaaSaady
