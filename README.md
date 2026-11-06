# Clinical Data Quality & Healthcare Performance Analytics

## Overview
An end-to-end healthcare informatics project using synthetic Synthea data, Python, Google BigQuery, SQL, and Looker Studio.

The project demonstrates clinical data ingestion, validation, cloud analytics, and HEDIS-inspired hypertension documentation monitoring.

## Architecture
Synthea CSV Data
    |
    v
Python Data Validation
    |
    v
Cleaned CSV and Parquet
    |
    v
Google BigQuery
    |
    v
SQL Analytics Views
    |
    v
Looker Studio Dashboard

## Dataset
| Table | Records |
|---|---:|
| Patients | 1,163 |
| Encounters | 61,459 |
| Conditions | 38,094 |
| Observations | 531,144 |
| Total | 631,860 |

## Data Quality
- Validated patient and encounter references.
- Checked source IDs and date formats.
- Identified 31,662 observations with missing encounter references.
- Investigated missing references and identified DALY, QALY, and QOLS observations.
- Found zero invalid nonempty encounter references.
- Preserved records rather than removing them.

## Hypertension Documentation Metric
Reporting period: 2019

Clinical codes:
- SNOMED CT 59621000: Hypertension
- LOINC 8480-6: Systolic blood pressure
- LOINC 8462-4: Diastolic blood pressure

Results:
- Eligible patients: 247
- Documented patients: 242
- Undocumented patients: 5
- Documentation rate: 97.98%

This is an illustrative HEDIS-inspired documentation measure, not an official HEDIS measure.

## Technology Stack
Python, Pandas, SQL, Google BigQuery, Apache Parquet, Looker Studio, Synthea.

## Limitations
- Synthetic data only.
- No production EHR integration.
- No official HEDIS certification or measure implementation.
- Blood-pressure observations are not required to be from the same encounter.
- No assessment of actual blood-pressure control.
- Some observations legitimately may not be encounter-associated, but their acceptability depends on downstream requirements.
