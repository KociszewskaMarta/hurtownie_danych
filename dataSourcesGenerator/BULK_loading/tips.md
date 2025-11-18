## BULK loading

---

### Correct order of BULK INSERT operations

Due to foreign key constraints, when performing BULK INSERT operations, it is essential to load data into the parent tables before the child tables. This ensures that all foreign key references are valid at the time of insertion.

Correct order:
1. Independent tables (no foreign keys)
   - `Tour`
   - `Client`
   - `Worker`

2. Tables with single dependecies
    - `TourEdition` (depends on `Tour`)

3. Tables with multiple dependencies
    - `Reservation` (depends on `Client`, `TourEdition`, `Worker`)
    - `Payment` (depends on `Reservation`)
    - `ReservationClient` (depends on `Reservation`, `Client`)
    - `ReservationWorker` (depends on `Reservation`, `Worker`)

---

### IDENTITY_INSERT for BULK INSERT

When performing BULK INSERT operations into tables with identity columns, you may need to enable `IDENTITY_INSERT` to allow explicit values to be inserted into the identity column. This is particularly useful when you want to maintain specific IDs from your source data.

Example:
```sql
-- Enable identity insert before bulk load
SET IDENTITY_INSERT Tour ON;
BULK INSERT Tour FROM 'path_to_file.csv' WITH (...);
SET IDENTITY_INSERT Tour OFF;
```

---

### Approach

Write script in python that will generate random data for each table considering foreign key constraints. Save each table data into separate `.bulk` files. Then use BULK INSERT statements to load data from these files into the database in the correct order.