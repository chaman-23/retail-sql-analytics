"""Run the reproducible retail SQL case study in an in-memory SQLite database."""
import argparse
import csv
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parent

def build_database():
    connection = sqlite3.connect(':memory:')
    try:
        connection.executescript((ROOT / 'schema.sql').read_text(encoding='utf-8'))
        connection.executescript((ROOT / 'sample.sql').read_text(encoding='utf-8'))
    except Exception:
        connection.close()
        raise
    return connection

def analyze(connection):
    results = {}
    for path in sorted((ROOT / 'queries').glob('*.sql')):
        cursor = connection.execute(path.read_text(encoding='utf-8'))
        results[path.stem] = ([col[0] for col in cursor.description], cursor.fetchall())
    return results

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--out', type=Path, default=Path('reports'))
    args = parser.parse_args()
    connection = None
    try:
        connection = build_database()
        results = analyze(connection)
        args.out.mkdir(parents=True, exist_ok=True)
        for name, (headers, rows) in results.items():
            with (args.out / f'{name}.csv').open('w', encoding='utf-8', newline='') as stream:
                writer = csv.writer(stream)
                writer.writerow(headers)
                writer.writerows(rows)
            print(f'{name}: {len(rows)} rows')
    except (OSError, sqlite3.Error) as exc:
        parser.exit(2, f'Error: {exc}\n')
    finally:
        if connection is not None:
            connection.close()

if __name__ == '__main__':
    main()
