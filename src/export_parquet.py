from pathlib import Path
import pandas as pd

root = Path(__file__).resolve().parents[1]
source = root / "data" / "clean"
target = root / "data" / "parquet"
target.mkdir(parents=True, exist_ok=True)

for name in ["patients", "encounters", "conditions", "observations"]:
    df = pd.read_csv(source / f"{name}.csv", dtype=str)
    df.to_parquet(target / f"{name}.parquet", index=False)
    print(f"{name}: {len(df):,} records exported")
