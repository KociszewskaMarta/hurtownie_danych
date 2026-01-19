#!/usr/bin/env python3
# Check for duplicate reservation IDs in reservations.bulk

file_path = 'data/reservations.bulk'

ids = set()
duplicates = 0
duplicate_ids = []

print(f"Reading {file_path}...")

with open(file_path, 'r', encoding='utf-8') as f:
    for line_num, line in enumerate(f, 1):
        line = line.strip()
        if line:
            parts = line.split('|')
            id_val = parts[0]
            
            if id_val in ids:
                duplicates += 1
                if len(duplicate_ids) < 10:  # Store first 10 duplicates as examples
                    duplicate_ids.append(f"ID {id_val} at line {line_num}")
            else:
                ids.add(id_val)

print(f"\nResults:")
print(f"Total rows: {len(ids) + duplicates}")
print(f"Unique IDs: {len(ids)}")
print(f"Duplicate IDs: {duplicates}")

if duplicates > 0:
    print(f"\nFirst duplicate examples:")
    for dupe in duplicate_ids:
        print(f"  - {dupe}")
else:
    print("\nNo duplicates found in reservation IDs!")
