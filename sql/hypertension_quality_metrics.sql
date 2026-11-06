WITH eligible_patients AS (
  SELECT DISTINCT
    p.id AS patient_id
  FROM `clinical_quality_demo.patients` p
  JOIN `clinical_quality_demo.conditions` c
    ON p.id = c.patient
  WHERE c.code = '59621000'
    AND SAFE_CAST(c.start AS DATE) < DATE '2020-01-01'
    AND DATE_DIFF(
      DATE '2019-12-31',
      SAFE_CAST(p.birthdate AS DATE),
      YEAR
    ) >= 18
    AND (
      p.deathdate IS NULL
      OR SAFE_CAST(p.deathdate AS DATE) > DATE '2019-12-31'
    )
),

blood_pressure_records AS (
  SELECT
    patient AS patient_id,
    COUNTIF(code = '8480-6') AS systolic_records,
    COUNTIF(code = '8462-4') AS diastolic_records
  FROM `clinical_quality_demo.observations`
  WHERE SAFE_CAST(date AS TIMESTAMP) >= TIMESTAMP('2019-01-01')
    AND SAFE_CAST(date AS TIMESTAMP) < TIMESTAMP('2020-01-01')
  GROUP BY patient
)

SELECT
  COUNT(*) AS eligible_patients,
  COUNTIF(
    COALESCE(bp.systolic_records, 0) > 0
    AND COALESCE(bp.diastolic_records, 0) > 0
  ) AS patients_with_bp_documented,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(
        COALESCE(bp.systolic_records, 0) > 0
        AND COALESCE(bp.diastolic_records, 0) > 0
      ),
      COUNT(*)
    ) * 100,
    2
  ) AS bp_documentation_rate
FROM eligible_patients e
LEFT JOIN blood_pressure_records bp
  ON e.patient_id = bp.patient_id