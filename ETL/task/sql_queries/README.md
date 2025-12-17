# Data Warehouse ETL Process 

## Database Schema

### Dimension Tables

#### `Wycieczka_D` (Trip Dimension)
Stores information about travel packages:
- `id_wycieczki` (PK) - Auto-incrementing trip identifier
- `nazwa_wycieczki` - Trip name
- `destynacja` - Destination
- `typ` - Trip type (relax, active, family, city-break)

#### `Data_D` (Date Dimension)
Time dimension for temporal analysis:
- `id_daty` (PK) - Auto-incrementing date identifier
- `rok` - Year (4-digit string)
- `pora_roku` - Season (Zima, Wiosna, Lato, Jesień)
- `miesiac` - Month name (in Polish)
- `dzien` - Day of month

#### `Klient_D` (Client Dimension)
Customer information with SCD Type 2 (Slowly Changing Dimension):
- `id_klienta` (PK) - Auto-incrementing client identifier
- `pesel_klienta` - Client's PESEL number (national ID)
- `czy_nowy` - Whether client is new (Tak/Nie)
- `data_wpisania` - Record entry date
- `data_wygasniecia` - Record expiration date (NULL for current records)

#### `Slowo_kluczowe_D` (Keyword Dimension)
Marketing keywords:
- `id_slowa_kluczowego` (PK) - Auto-incrementing keyword identifier
- `slowo_kluczowe` - Keyword text

#### `Nazwa_kampanii_D` (Campaign Name Dimension)
Campaign identifiers:
- `id_nazwy_kampanii` (PK) - Auto-incrementing campaign name identifier
- `nazwa_kampanii` - Campaign name

#### `Junk_D` (Junk Dimension)
Low-cardinality attributes:
- `id_junk` (PK) - Auto-incrementing junk dimension identifier
- `status_oplacenia` - Payment status (Tak/Nie)

### Fact Tables

#### `Rezerwacja_F` (Reservation Fact)
Stores reservation transactions:
- **Dimension Keys**: id_wycieczki, id_nazwy_kampanii, id_klienta, id_daty, id_junk (composite PK)
- **Measures**: 
  - `kwota_transakcji` - Transaction amount
  - `cena_turnusu` - Trip session price

#### `Kampania_F` (Campaign Fact)
Marketing campaign performance metrics:
- **Dimension Keys**: id_wycieczki, id_daty, id_slowa_kluczowego, id_nazwy_kampanii (composite PK)
- **Measures**:
  - `wspolczynnik_konwersji` - Conversion rate
  - `koszt_kampanii` - Campaign cost
  - `liczba_klikniec` - Number of clicks
  - `koszt_na_klikniecie` - Cost per click

## SQL Scripts

### 1. `create_statements.sql`
**Purpose**: Creates the complete data warehouse schema

**Usage**: Run this script first to initialize the data warehouse structure.

### 2. `load_date.sql`
**Purpose**: Populates the Date dimension with a date range

**What it does**:
- Generates dates from January 1, 2015 to July 1, 2025
- Calculates and inserts:
  - Year (4-digit string)
  - Season (Zima/Wiosna/Lato/Jesień)
  - Month names in Polish
  - Day of month
- Uses a WHILE loop to iterate through each date

**Usage**: Run after creating tables to populate the date dimension.

### 3. `load_junk.sql`
**Purpose**: Populates the Junk dimension with payment status values

**What it does**:
- Inserts two records for payment status:
  - 'Tak' (Yes - paid)
  - 'Nie' (No - not paid)

**Usage**: Run after creating tables to populate the junk dimension.

### 4. `load_trips.sql`
**Purpose**: Loads trip data from the source database

**What it does**:
- Extracts unique trips from `go_explore_travel_agency.dbo.Tour`
- Transforms trip types to Polish labels
- Prevents duplicate entries using NOT EXISTS check
- Maps tour types: Relax→relaks, Active→aktywnie, Family→rodzinne, City-break→city-break

**Usage**: Run to synchronize trip dimension with source data. Can be run multiple times safely.

### 5. `load_clients.sql`
**Purpose**: Implements SCD Type 2 for client dimension

**What it does**:
- **Step 1**: Calculates whether each client is new (single reservation = 'Tak', multiple = 'Nie')
- **Step 2**: Expires old records where 'czy_nowy' status changed (sets `data_wygasniecia` to current date)
- **Step 3**: Inserts new records for:
  - Brand new clients
  - Clients with changed 'czy_nowy' status

**SCD Type 2 Implementation**:
- Maintains historical changes in client status
- Current records have `data_wygasniecia = NULL`
- Historical records have expiration dates
- Tracks when clients transition from new to returning

**Usage**: Run regularly to update client dimension. First run inserts all clients, subsequent runs track changes.

### 6. `load_marketing_data.sql`
**Purpose**: Loads marketing campaign data from CSV file

**What it does**:
1. Creates temporary table `Marketing_Temp` with CSV structure
2. Uses BULK INSERT to load data from CSV file
3. Converts decimal separators (comma to period) for numeric fields
4. Extracts and inserts unique keywords into `Slowo_kluczowe_D`
5. Extracts and inserts unique campaign names into `Nazwa_kampanii_D`
6. Drops temporary table after processing

**CSV File Location**: 
```
C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\dataSourcesGenerator\python_scripts\generating_data\marketing_data.csv
```

**CSV Structure**:
- Date, Campaign_Name, Ad_group, Trip_id, Keyword, Impressions, Clicks, CTR, Cost, Conversion_Rate

**Usage**: Run to import marketing data. Update file path as needed. Prevents duplicates with NOT EXISTS checks.

### 8. `load_rezerwacja_fact_corrected.sql`
**Purpose**: Loads reservation fact table by joining source data with dimension tables

**What it does**:
1. **Loads Marketing Data**: 
   - Creates temporary table `Marketing_Temp`
   - Uses BULK INSERT to load marketing campaign CSV data
   
2. **Inserts into Rezerwacja_F** using complex JOIN logic:
   - **Source Tables** (from `sample_travel_agency_database`):
     - `Reservation` - main reservation data
     - `ReservationClient` - links reservations to clients
     - `Client` - client information
     - `TourEdition` - specific tour session details
     - `Tour` - tour/trip information
     - `Payment` - payment transactions (LEFT JOIN - may not exist yet)
   
3. **Dimension Lookups**:
   - **Wycieczka_D**: Matches by trip name (`nazwa_wycieczki = t.name`)
   - **Klient_D**: Matches by PESEL AND ensures active record (`data_wygasniecia IS NULL` for SCD Type 2)
   - **Nazwa_kampanii_D**: Matches via Marketing_Temp CSV by joining `Trip_id` to `tour_id`, then to campaign name
   - **Data_D**: Matches by year, month, and day from `reservation_date`
   - **Junk_D**: Matches payment status - transforms `'Paid'` → `'Tak'`, others → `'Nie'`

4. **Measures Calculation**:
   - `kwota_transakcji`: Uses `ISNULL(p.amount, 0)` - returns 0 if no payment exists
   - `cena_turnusu`: Direct copy from `TourEdition.price`

5. **Marketing Campaign Logic**:
   - Extracts campaign name from CSV by matching `Trip_id` to `tour_id`
   - If multiple campaigns exist for same trip, uses `MIN(Campaing_Name)` to select first one
   - Uses LEFT JOIN so records without campaigns can be filtered

6. **Filtering**:
   - Only includes reservations where ALL dimensions exist (NOT NULL checks)
   - **Critical**: `kamp.id_nazwy_kampanii IS NOT NULL` - only loads reservations with marketing campaigns
   - Ensures referential integrity with dimension tables

7. **SCD Type 2 Handling**:
   - Client dimension lookup includes `data_wygasniecia IS NULL` to get current/active client record
   - Ensures historical client changes don't create duplicate facts

**Data Flow**:
```
Source DB Reservation → Join Client (via ReservationClient)
                     → Join Tour (via TourEdition)
                     → Join Payment (optional)
                     → Match Wycieczka_D by name
                     → Match Klient_D by PESEL (active record only)
                     → Match Campaign via CSV Trip_id
                     → Match Nazwa_kampanii_D by campaign name
                     → Match Data_D by date components
                     → Match Junk_D by payment status
                     → Insert into Rezerwacja_F
```

**Important Notes**:
- Uses `DISTINCT` to prevent duplicate rows
- Marketing_Temp is dropped after loading
- Only loads reservations that have associated marketing campaigns
- Handles missing payments gracefully with `ISNULL`

**Usage**: Run after loading all dimensions. Can be run incrementally with WHERE clauses to load only new reservations. Uncomment `TRUNCATE TABLE Rezerwacja_F` for full reload.

### 9. `delete_statements.sql`
**Purpose**: Clears all data from tables while preserving structure

**Usage**: Use when you need to reload all data from scratch or reset the warehouse.

### 10. `drop_stetements.sql`
**Purpose**: Completely removes all tables from the database

**Usage**: Use for complete teardown before recreating schema with `create_statements.sql`.

## Databases

### 1. `go_explore_travel_agency` - snapshot T1, original database from source system

TODO: fix, load data from source system (problem with generated type od payment in payment table)

### 2. `go_explore_travel_agency_t2` - snapshot T2, original database from source system (T1 with additional data (new reservations, clients, workers with different statuses))

TODO: fix, load data from source system (problem with generated type od payment in payment table)

### 3. `HD_warhouse` - data warehouse database for development and testing (used for Task 3 and 4, showing the implementation of data warehouse concepts)

### 4. `HD_warhouse_real_data` - data warehouse database for production use (used for Task 5 with real data from source systems)

### 5. `sample_client_reservation` - sample database for tasting SCD Type 2 implementation, contains only Client, Reservation and ReservationClient tables with minimal data

### 6. `SCD_test` - sample database for testing SCD Type 2 concepts, contains only Client_D

### 7. `sample_warehouse` - sample data warehouse database for testing

### 8. `sample_travel_agency_database` - sample source database for testing, contains all tables from original source system with minimal data for testing

## Testing SCD Type 2

- Run `sample_clients_reservations.sql` to create and populate `sample_client_reservation` database

- Run `sample_warehouse.sql` to create `sample_warehouse` database with `Client_D` table

- Run `load_client_test.sql` to load first snapshot of clients

- Run `insert_T2_clients.sql` to add new reservations and clients for second snapshot

- In `sample_warehouse` ypu can see that only changed clients are updated with SCD Type 2 logic (only those rows are affected) and new records are inserted accordingly

## Testing Rezerwacja_F Fact Table
- Use `verify_rezerwacja_fact.sql` to export data from `Rezerwacja_F` fact table in data warehouse to CSV file
- Use `ETL/task/sql_queries/facts_test/compare_exports.py` script to compare data exported from source system and data from `Rezerwacja_F` fact table in data warehouse



## ETL Process Flow

### Initial Load (First Time Setup)

1. **Create Schema**: Run `create_statements.sql`
2. **Load Static Dimensions**:
   - Run `load_date.sql` (Date dimension)
   - Run `load_junk.sql` (Junk dimension)
3. **Load Variable Dimensions**:
   - Run `load_trips.sql` (Trip dimension from source)
   - Run `load_marketing_data.sql` (Keywords and Campaign names from CSV)
   - Run `load_clients.sql` (Client dimension with SCD Type 2)
4. **Load Facts**: (Scripts not included - load Rezerwacja_F and Kampania_F)
   - Run `load_rezerwacja_fact_corrected.sql` (loads reservation facts)

### Incremental Load (Regular Updates)

1. **Update Dimensions**:
   - Run `load_trips.sql` (adds new trips)
   - Run `load_marketing_data.sql` (adds new keywords/campaigns)
   - Run `load_clients.sql` (tracks client status changes)
2. **Load New Facts**: Load new reservations and campaign data

### Full Reload (Data Refresh)

1. Run `delete_statements.sql` (clear all data)
2. Follow Initial Load process

### Complete Rebuild

1. Run `drop_stetements.sql` (remove all tables)
2. Follow Initial Load process starting with `create_statements.sql`



