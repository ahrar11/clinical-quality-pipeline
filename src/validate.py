from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
CLEAN = ROOT / "data" / "clean"
REPORTS = ROOT / "reports"

CLEAN.mkdir(parents=True, exist_ok=True)
REPORTS.mkdir(parents=True, exist_ok=True)

files = ["patients", "encounters", "conditions", "observations"]
data = {}
results = []

for name in files:
    df = pd.read_csv(RAW / f"{name}.csv", dtype=str)
    df.columns = df.columns.str.lower()

    for col in df.columns:
        df[col] = df[col].str.strip()

    data[name] = df

patient_ids = set(data["patients"]["id"].dropna())
encounter_ids = set(data["encounters"]["id"].dropna())

for name, df in data.items():
    issues = {}

    issues["missing_patient_reference"] = (
        (~df["patient"].isin(patient_ids)).sum()
        if name != "patients" else 0
    )

    issues["duplicate_ids"] = (
        df["id"].duplicated().sum()
        if "id" in df.columns else 0
    )

    if "encounter" in df.columns:
        issues["invalid_encounter_reference"] = (
            (~df["encounter"].isna() & ~df["encounter"].isin(encounter_ids)).sum()
        )
    else:
        issues["invalid_encounter_reference"] = 0

    date_columns = [
        c for c in ["birthdate", "start", "stop", "date"]
        if c in df.columns
    ]

    issues["invalid_dates"] = sum(
        (
            df[col].notna()
            & pd.to_datetime(df[col], errors="coerce", utc=True).isna()
        ).sum()
        for col in date_columns
    )

    df.to_csv(CLEAN / f"{name}.csv", index=False)

    results.append({
        "table": name,
        "total_rows": len(df),
        **issues
    })

    print(f"Processed {name}: {len(df):,} rows")

report = pd.DataFrame(results)
report.to_csv(REPORTS / "quality_report.csv", index=False)

print("\nDATA QUALITY REPORT")
print(report.to_string(index=False))
print("\nSaved cleaned data and validation report.")
