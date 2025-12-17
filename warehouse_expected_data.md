# Expected Warehouse Data Based on Sample Database

This document shows what records should be in each warehouse table after running the ETL process on the sample travel agency database.

## Source Database Summary
- **10 Tours** (tour_id 1-10)
- **15 TourEditions** (tour_edition_id 1-15)
- **20 Reservations** (reservation_id 1-20)
- **12 Clients** (with different PESELs)
- **8 Workers**
- **18 Payments** (3 reservations unpaid/processing)
- **30 Marketing Records** (from CSV file)

---

## DIMENSION TABLES

### 1. `Wycieczka_D` (Trip Dimension)
**10 records** - one for each unique tour in source database

| id_wycieczki | nazwa_wycieczki | destynacja | typ |
|--------------|-----------------|------------|-----|
| 1 | Historical Landmarks Journey | Rome, Italy | relaks |
| 2 | Tropical Paradise Getaway | Bali, Indonesia | rodzinne |
| 3 | Mountain Adventure Expedition | Swiss Alps, Switzerland | aktywnie |
| 4 | Cultural Heritage Tour | Kyoto, Japan | rodzinne |
| 5 | City Explorer Package | Barcelona, Spain | city-break |
| 6 | Wildlife Safari Experience | Serengeti, Tanzania | aktywnie |
| 7 | Art and Architecture Walk | Paris, France | relaks |
| 8 | Island Hopping Adventure | Greek Islands | rodzinne |
| 9 | Desert Discovery Tour | Dubai, UAE | city-break |
| 10 | Northern Lights Quest | Iceland | aktywnie |

**Source:** `load_trips.sql` transforms data from `Tour` table
- Maps English tour_type to Polish: Relax→relaks, Active→aktywnie, Family→rodzinne, City-break→city-break

---

### 2. `Data_D` (Date Dimension)
**3,835 records** - one for each day from 2015-01-01 to 2025-07-01

**Sample records:**

| id_daty | rok | pora_roku | miesiac | dzien |
|---------|-----|-----------|---------|-------|
| 1 | 2015 | Zima | Styczeń | 1 |
| 2 | 2015 | Zima | Styczeń | 2 |
| ... | ... | ... | ... | ... |
| 3471 | 2024 | Wiosna | Maj | 10 |
| 3472 | 2024 | Wiosna | Maj | 11 |
| ... | ... | ... | ... | ... |
| 3835 | 2025 | Lato | Lipiec | 1 |

**Date ranges that matter for facts:**
- Reservation dates: 2024-05-10 to 2024-12-31
- Marketing dates: 2024-01-15 to 2024-11-22

**Source:** `load_date.sql` generates all dates programmatically
- Polish season names: Zima (Dec-Feb), Wiosna (Mar-May), Lato (Jun-Aug), Jesień (Sep-Nov)
- Polish month names

---

### 3. `Klient_D` (Client Dimension - SCD Type 2)
**Initial: 12 records** (one per client, all new customers initially)

After first reservation: some clients will have **czy_nowy = 'Nie'** (multiple reservations)

**Initial State (all clients are new):**

| id_klienta | pesel_klienta | czy_nowy | data_wpisania | data_wygasniecia |
|------------|---------------|----------|---------------|------------------|
| 1 | 95010143210 | Tak | GETDATE() | NULL |
| 2 | 96020287654 | Tak | GETDATE() | NULL |
| 3 | 94030365432 | Tak | GETDATE() | NULL |
| 4 | 97040423456 | Tak | GETDATE() | NULL |
| 5 | 93050598765 | Tak | GETDATE() | NULL |
| 6 | 98060612345 | Tak | GETDATE() | NULL |
| 7 | 92070754321 | Tak | GETDATE() | NULL |
| 8 | 99080876543 | Tak | GETDATE() | NULL |
| 9 | 91090932109 | Tak | GETDATE() | NULL |
| 10 | 00100098765 | Tak | GETDATE() | NULL |
| 11 | 95110145678 | Tak | GETDATE() | NULL |
| 12 | 96120234567 | Tak | GETDATE() | NULL |

**After tracking reservations:**

Clients with multiple reservations will have **2 records** (SCD Type 2):
- **95010143210** (Anna Kowalska) - reservations 1, 11, 17 → 3 reservations
- **96020287654** (Jan Nowak) - reservations 2, 12 → 2 reservations  
- **00100098765** (Marek Król) - reservations 10, 16, 18 → 3 reservations
- **98060612345** (Adam Piotrowski) - reservations 6, 13 → 2 reservations
- **94030365432** (Maria Wiśniewska) - reservations 3, 14 → 2 reservations
- **99080876543** (Krzysztof Pawłowski) - reservations 8, 15 → 2 reservations

These 6 clients will have their old record expired and a new record:
- Old record: `czy_nowy = 'Tak'`, `data_wygasniecia = GETDATE()`
- New record: `czy_nowy = 'Nie'`, `data_wpisania = GETDATE()`, `data_wygasniecia = NULL`

**Total after updates: 18 records** (6 expired + 12 current)

**Source:** `load_clients.sql` implements SCD Type 2
- Counts reservations per client
- First reservation: czy_nowy = 'Tak'
- Subsequent reservations: czy_nowy = 'Nie'

---

### 4. `Slowo_kluczowe_D` (Keyword Dimension)
**26 unique keywords** from marketing CSV

| id_slowa_kluczowego | slowo_kluczowe |
|---------------------|----------------|
| 1 | dla dzieci |
| 2 | rodzinne wakacje |
| 3 | luksusowe podróże |
| 4 | plaże |
| 5 | aktywne wakacje |
| 6 | sport |
| 7 | oferty specjalne |
| 8 | romantyczne |
| 9 | egzotyka |
| 10 | dzika przyroda |
| 11 | spa |
| 12 | 5-gwiazdek |
| 13 | nieodkryte miejsca |
| 14 | budżetowe wakacje |
| 15 | relaks i wellness |
| 16 | ekstremalne |
| 17 | przygoda |
| 18 | joga |
| 19 | spokojne wakacje |
| 20 | animacje dla dzieci |
| 21 | wysoki standard |
| 22 | eksploracja |
| 23 | dla par |
| 24 | oszczędne podróże |
| 25 | (and others from CSV) |

**Source:** `load_marketing_data.sql` extracts unique keywords from `Marketing_Temp.Keyword` column

---

### 5. `Nazwa_kampanii_D` (Campaign Name Dimension)
**9 unique campaign names** from marketing CSV

| id_nazwy_kampanii | nazwa_kampanii |
|-------------------|----------------|
| 1 | Rodzinne wakacje |
| 2 | Luksusowe podróże |
| 3 | Egzotyczne destynacje |
| 4 | Przygoda i eksploracja |
| 5 | Wakacje budżetowe |
| 6 | Wakacje dla par |
| 7 | Relaks i wellness |
| 8 | Wakacje dla seniorów |
| 9 | Wakacje z dziećmi |

**Source:** `load_marketing_data.sql` extracts unique campaign names from `Marketing_Temp.Campaing_Name` column

---

### 6. `Junk_D` (Junk Dimension)
**2 records** - payment status flags

| id_junk | status_oplacenia |
|---------|------------------|
| 1 | Nie |
| 2 | Tak |

**Source:** `load_junk.sql` creates these two static records

---

## FACT TABLES

### 7. `Rezerwacja_F` (Reservation Fact)
**20 records** - one for each reservation in source database

**Sample records:**

| id_wycieczki | id_nazwy_kampanii | id_klienta | id_daty | id_junk | kwota_transakcji | cena_turnusu |
|--------------|-------------------|------------|---------|---------|------------------|--------------|
| 1 | 1 | 1 | [2024-05-10] | 2 | 2500.00 | 2500.00 |
| 1 | 1 | 2 | [2024-05-15] | 2 | 2500.00 | 2500.00 |
| 2 | 1 | 3 | [2024-06-01] | 2 | 3200.00 | 3200.00 |
| 3 | 4 | 4 | [2024-06-20] | 1 | NULL | 4500.00 |
| 4 | 1 | 5 | [2024-07-15] | 2 | 2800.00 | 2800.00 |
| 5 | 6 | 6 | [2024-08-01] | 2 | 1800.00 | 1800.00 |
| 5 | 6 | 7 | [2024-08-10] | 1 | NULL | 1800.00 |
| 6 | 4 | 8 | [2024-09-05] | 2 | 5200.00 | 5200.00 |
| ... | ... | ... | ... | ... | ... | ... |

**Key transformations:**
- `id_daty` → matches reservation_date to Data_D (year, month, day)
- `id_junk` → 2 (Tak) if payment exists, 1 (Nie) if no payment
- `id_nazwy_kampanii` → matched via Marketing_Temp by Trip_id
- `kwota_transakcji` → Payment.amount (NULL for unpaid reservations)
- `cena_turnusu` → TourEdition.price

**Unpaid/Processing reservations (id_junk = 1):**
- Reservation 4: Processing
- Reservation 7: Unpaid
- Reservation 9: Processing (partial payment 1500.00)
- Reservation 13: Unpaid
- Reservation 15: Processing
- Reservation 19: Processing (partial payment 1900.00)

**Source:** `load_rezerwacja_fact.sql`
- Joins Reservation → TourEdition → Tour → dimensions
- Links to Marketing_Temp to get campaign name
- Payment status determines junk dimension

---

### 8. `Kampania_F` (Campaign Fact)
**30 records** - one for each row in marketing CSV

**Sample records:**

| id_wycieczki | id_daty | id_slowa_kluczowego | id_nazwy_kampanii | wspolczynnik_konwersji | koszt_kampanii | liczba_klikniec | koszt_na_klikniecie |
|--------------|---------|---------------------|-------------------|------------------------|----------------|-----------------|---------------------|
| 1 | [2024-01-15] | 1 | 1 | 18.45 | 2151 | 12450 | 0 |
| 1 | [2024-02-20] | 2 | 1 | 15.20 | 1875 | 8830 | 0 |
| 2 | [2024-03-10] | 3 | 2 | 22.10 | 3251 | 18650 | 0 |
| 2 | [2024-03-25] | 4 | 3 | 19.50 | 2890 | 25300 | 0 |
| 3 | [2024-04-05] | 5 | 4 | 25.30 | 3850 | 22100 | 0 |
| 3 | [2024-04-20] | 6 | 4 | 28.15 | 4126 | 28900 | 0 |
| 4 | [2024-05-10] | 2 | 1 | 16.80 | 2320 | 15200 | 0 |
| ... | ... | ... | ... | ... | ... | ... | ... |

**Key transformations:**
- `id_wycieczki` → from Marketing_Temp.Trip_id (cast to INT)
- `id_slowa_kluczowego` → matched via Keyword lookup
- `id_nazwy_kampanii` → matched via Campaing_Name lookup
- `wspolczynnik_konwersji` → Conversion_Rate (comma replaced with dot, cast to DECIMAL)
- `koszt_kampanii` → Cost (cast to INT)
- `liczba_klikniec` → Clicks (cast to INT)
- `koszt_na_klikniecie` → Cost / Clicks (calculated)

**Note:** The `id_daty` field is **missing** in the current `load_kampania_fact.sql` implementation! 
The fact table definition includes it, but the INSERT statement doesn't populate it.

**Source:** `load_kampania_fact.sql` (via Marketing_Temp staging table)
- Creates temp table from CSV
- Replaces commas with dots for decimals
- Joins to dimensions for foreign keys
- Calculates cost per click

---

## ETL EXECUTION ORDER

To populate the warehouse correctly, execute in this order:

1. **Create warehouse schema:** `create_statements.sql`
2. **Load Date dimension:** `load_date.sql` (generates dates 2015-2025)
3. **Load Trips dimension:** `load_trips.sql` (from Tour table)
4. **Load Junk dimension:** `load_junk.sql` (2 static records)
5. **Load Marketing data:** `load_marketing_data.sql` (populates keywords & campaigns from CSV)
6. **Load Clients dimension:** `load_clients.sql` (SCD Type 2 - initial load)
7. **Load Rezerwacja fact:** `load_rezerwacja_fact.sql` (depends on all dimensions)
8. **Load Kampania fact:** `load_kampania_fact.sql` (depends on trips, keywords, campaigns, dates)

---

## DATA QUALITY NOTES

### Issues Found:

1. **Kampania_F missing id_daty:** The current `load_kampania_fact.sql` doesn't include date dimension FK in INSERT, though it's defined in the fact table schema.

2. **Case sensitivity:** Payment status logic uses 'TAK'/'NIE' (uppercase) but Junk_D contains 'Tak'/'Nie' - needs consistent casing.

3. **Marketing campaigns not linked to all trips:** Some tours (like 5, 9) have generic campaigns assigned, affecting fact table completeness.

4. **NULL campaign names:** Some reservations may have NULL id_nazwy_kampanii if no marketing data exists for that tour_id.

### Expected Counts Summary:

| Table | Expected Records |
|-------|------------------|
| Wycieczka_D | 10 |
| Data_D | 3,835 |
| Klient_D | 18 (after SCD updates) |
| Slowo_kluczowe_D | 26 |
| Nazwa_kampanii_D | 9 |
| Junk_D | 2 |
| **Rezerwacja_F** | **20** |
| **Kampania_F** | **30** |

