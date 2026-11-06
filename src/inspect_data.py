from pathlib import Path
import pandas as pd

DATA_DIR = Path(__file__).resolve().parents[1] / "data" / "raw"

files = [
    "patients.csv",
    "encounters.csv",
    "conditions.csv",
    "observations.csv"
]

for filename in files:
    path = DATA_DIR / filename

    if not path.exists():
        print(f"Missing file: {filename}")
        continue

    df = pd.read_csv(path, low_memory=False)

    print(f"\n{'=' * 50}")
    print(f"File: {filename}")
    print(f"Rows: {len(df):,}")
    print(f"Columns: {len(df.columns)}")
    print(f"Column names: {list(df.columns)}")
    print("\nFirst 3 records:")
    print(df.head(3).to_string(index=False))
