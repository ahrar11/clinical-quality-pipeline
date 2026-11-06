WITH records AS (
  SELECT
    SUM(total_records) AS total_records,
    SUM(invalid_patient_references) AS invalid_patient_refs,
    SUM(invalid_encounter_references) AS invalid_encounter_refs,
    SUM(missing_encounter_references) AS missing_encounter_refs
  FROM `clinical_quality_demo.data_quality_metrics`
),

patients AS (
  SELECT
    COUNT(*) AS total_patients,
    SUM(total_encounters) AS total_encounters
  FROM `clinical_quality_demo.patient_summary`
)

SELECT
  p.total_patients,
  p.total_encounters,
  r.total_records,
  r.invalid_patient_refs,
  r.invalid_encounter_refs,
  r.missing_encounter_refs,
  h.eligible_patients,
  h.patients_with_bp_documented,
  h.bp_documentation_rate
FROM patients p
CROSS JOIN records r
CROSS JOIN `clinical_quality_demo.hypertension_quality_metrics` h