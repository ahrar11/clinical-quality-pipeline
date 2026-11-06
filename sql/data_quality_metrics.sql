WITH patient_checks AS (
  SELECT
    'patients' AS table_name,
    COUNT(*) AS total_records,
    COUNTIF(id IS NULL OR TRIM(id) = '') AS missing_ids,
    COUNT(*) - COUNT(DISTINCT id) AS duplicate_ids,
    0 AS invalid_patient_references,
    0 AS missing_encounter_references,
    0 AS invalid_encounter_references,
    0 AS invalid_date_ranges
  FROM `clinical_quality_demo.patients`
),

encounter_checks AS (
  SELECT
    'encounters',
    COUNT(*),
    COUNTIF(e.id IS NULL OR TRIM(e.id) = ''),
    COUNT(*) - COUNT(DISTINCT e.id),
    COUNTIF(p.id IS NULL),
    0,
    0,
    COUNTIF(
      SAFE_CAST(e.start AS TIMESTAMP) >
      SAFE_CAST(e.stop AS TIMESTAMP)
    )
  FROM `clinical_quality_demo.encounters` e
  LEFT JOIN `clinical_quality_demo.patients` p
    ON e.patient = p.id
),

condition_checks AS (
  SELECT
    'conditions',
    COUNT(*),
    0,
    0,
    COUNTIF(p.id IS NULL),
    COUNTIF(c.encounter IS NULL OR TRIM(c.encounter) = ''),
    COUNTIF(
      c.encounter IS NOT NULL
      AND TRIM(c.encounter) != ''
      AND e.id IS NULL
    ),
    COUNTIF(
      SAFE_CAST(c.start AS DATE) >
      SAFE_CAST(c.stop AS DATE)
    )
  FROM `clinical_quality_demo.conditions` c
  LEFT JOIN `clinical_quality_demo.patients` p
    ON c.patient = p.id
  LEFT JOIN `clinical_quality_demo.encounters` e
    ON c.encounter = e.id
),

observation_checks AS (
  SELECT
    'observations',
    COUNT(*),
    0,
    0,
    COUNTIF(p.id IS NULL),
    COUNTIF(o.encounter IS NULL OR TRIM(o.encounter) = ''),
    COUNTIF(
      o.encounter IS NOT NULL
      AND TRIM(o.encounter) != ''
      AND e.id IS NULL
    ),
    0
  FROM `clinical_quality_demo.observations` o
  LEFT JOIN `clinical_quality_demo.patients` p
    ON o.patient = p.id
  LEFT JOIN `clinical_quality_demo.encounters` e
    ON o.encounter = e.id
)

SELECT * FROM patient_checks
UNION ALL SELECT * FROM encounter_checks
UNION ALL SELECT * FROM condition_checks
UNION ALL SELECT * FROM observation_checks