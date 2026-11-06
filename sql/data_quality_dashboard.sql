SELECT
  table_name,
  total_records,
  missing_encounter_references,
  invalid_encounter_references,
  invalid_patient_references,
  missing_ids,
  duplicate_ids,
  invalid_date_ranges
FROM `clinical_quality_demo.data_quality_metrics`