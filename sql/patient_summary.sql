SELECT
  p.id AS patient_id,
  p.birthdate,
  p.gender,
  p.race,
  p.ethnicity,
  p.state,
  COUNT(DISTINCT e.id) AS total_encounters,
  MAX(SAFE_CAST(e.start AS TIMESTAMP)) AS last_encounter

FROM `clinical_quality_demo.patients` p

LEFT JOIN `clinical_quality_demo.encounters` e
  ON p.id = e.patient

GROUP BY
  p.id,
  p.birthdate,
  p.gender,
  p.race,
  p.ethnicity,
  p.state