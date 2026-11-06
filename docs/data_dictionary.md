# Clinical Data Dictionary

## Patients
- id: Unique patient identifier
- birthdate: Date of birth
- deathdate: Recorded date of death
- gender: Patient gender
- race: Patient race
- ethnicity: Patient ethnicity
- state: Geographic state

## Encounters
- id: Unique encounter identifier
- patient: Foreign key to patients.id
- start: Encounter start timestamp
- stop: Encounter end timestamp
- encounterclass: Encounter classification
- code: Encounter procedure code
- description: Encounter description

## Conditions
- patient: Foreign key to patients.id
- encounter: Foreign key to encounters.id
- start: Condition onset date
- stop: Condition end date
- code: Clinical condition code
- description: Clinical condition description

## Observations
- patient: Foreign key to patients.id
- encounter: Encounter reference, which may be missing
- date: Observation timestamp
- category: Observation category
- code: Observation code
- description: Observation description
- value: Recorded observation result
- units: Measurement units
- type: Observation result type

## Clinical Terminology
- SNOMED CT 59621000: Hypertension
- LOINC 8480-6: Systolic blood pressure
- LOINC 8462-4: Diastolic blood pressure

## Data Relationships
patients.id -> encounters.patient
patients.id -> conditions.patient
patients.id -> observations.patient
encounters.id -> conditions.encounter
encounters.id -> observations.encounter

## Data Lineage
Synthea CSV -> Python validation -> Clean CSV -> Parquet -> BigQuery -> SQL views -> Looker Studio

## Known Limitations
- Conditions and observations do not have dedicated unique row IDs.
- Missing encounter references do not necessarily indicate invalid clinical observations.
- Duplicate full-row detection is not implemented.
- This is synthetic educational data, not actual patient information.
