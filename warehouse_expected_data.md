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

## SOURCE DATABASE TABLES (sample_travel_agency_database)

### Tour Table
**10 records**

| tour_id | name | destination | tour_type | attractions |
|---------|------|-------------|-----------|-------------|
| 1 | Historical Landmarks Journey | Rome, Italy | Relax | Ancient Ruins, Museums, Local Markets |
| 2 | Tropical Paradise Getaway | Bali, Indonesia | Family | Beaches, Coral Reefs, Tropical Forests |
| 3 | Mountain Adventure Expedition | Swiss Alps, Switzerland | Active | Hiking Trails, Mountain Peaks, Glaciers |
| 4 | Cultural Heritage Tour | Kyoto, Japan | Family | Temples, Gardens, Cultural Festivals |
| 5 | City Explorer Package | Barcelona, Spain | City-break | Architecture, Beaches, Nightlife |
| 6 | Wildlife Safari Experience | Serengeti, Tanzania | Active | Safari Drives, Wildlife Viewing, National Parks |
| 7 | Art and Architecture Walk | Paris, France | Relax | Art Galleries, Museums, Historical Buildings |
| 8 | Island Hopping Adventure | Greek Islands | Family | Island Tours, Beaches, Local Cuisine |
| 9 | Desert Discovery Tour | Dubai, UAE | City-break | Desert Safari, Modern Architecture, Shopping |
| 10 | Northern Lights Quest | Iceland | Active | Glaciers, Waterfalls, Northern Lights Viewing |

---

### TourEdition Table
**15 records**

| tour_edition_id | start_date | end_date | price | available_slots | tour_id |
|-----------------|------------|----------|-------|-----------------|---------|
| 1 | 2024-06-15 | 2024-06-26 | 2500.00 | 20 | 1 |
| 2 | 2024-07-10 | 2024-07-20 | 3200.00 | 15 | 2 |
| 3 | 2024-08-05 | 2024-08-15 | 4500.00 | 12 | 3 |
| 4 | 2024-09-01 | 2024-09-12 | 2800.00 | 18 | 4 |
| 5 | 2024-10-15 | 2024-10-22 | 1800.00 | 25 | 5 |
| 6 | 2024-11-10 | 2024-11-20 | 5200.00 | 10 | 6 |
| 7 | 2025-01-15 | 2025-01-22 | 2100.00 | 20 | 7 |
| 8 | 2025-02-20 | 2025-03-02 | 3500.00 | 16 | 8 |
| 9 | 2025-03-10 | 2025-03-17 | 2900.00 | 22 | 9 |
| 10 | 2025-04-05 | 2025-04-15 | 4800.00 | 14 | 10 |
| 11 | 2024-12-01 | 2024-12-08 | 2600.00 | 18 | 1 |
| 12 | 2025-05-20 | 2025-05-30 | 3300.00 | 15 | 2 |
| 13 | 2025-06-15 | 2025-06-25 | 4600.00 | 10 | 3 |
| 14 | 2025-07-10 | 2025-07-21 | 2900.00 | 20 | 4 |
| 15 | 2025-08-05 | 2025-08-12 | 1900.00 | 25 | 5 |

---

### Worker Table
**8 records**

| worker_pesel | first_name | last_name | email | phone_number | role |
|--------------|------------|-----------|-------|--------------|------|
| 90010112345 | Jan | Kowalski | jan.kowalski@goexplore.com | 123456789 | Manager |
| 85020298765 | Anna | Nowak | anna.nowak@goexplore.com | 234567890 | Travel Consultant |
| 92030354321 | Piotr | Wiśniewski | piotr.wisniewski@goexplore.com | 345678901 | Sales Manager |
| 88040467890 | Maria | Wójcik | maria.wojcik@goexplore.com | 456789012 | Marketing Specialist |
| 91050523456 | Tomasz | Kamiński | tomasz.kaminski@goexplore.com | 567890123 | Operations Manager |
| 87060609876 | Katarzyna | Lewandowska | katarzyna.lewandowska@goexplore.com | 678901234 | Finance Officer |
| 93070734567 | Michał | Zieliński | michal.zielinski@goexplore.com | 789012345 | Travel Consultant |
| 89080898765 | Magdalena | Szymańska | magdalena.szymanska@goexplore.com | 890123456 | Customer Service Representative |

---

### Client Table
**12 records**

| client_pesel | first_name | last_name | email | phone_number |
|--------------|------------|-----------|-------|--------------|
| 95010143210 | Anna | Kowalska | anna.kowalska@email.com | 111222333 |
| 96020287654 | Jan | Nowak | jan.nowak@email.com | 222333444 |
| 94030365432 | Maria | Wiśniewska | maria.wisniewska@email.com | 333444555 |
| 97040423456 | Piotr | Dąbrowski | piotr.dabrowski@email.com | 444555666 |
| 93050598765 | Zofia | Krawczyk | zofia.krawczyk@email.com | 555666777 |
| 98060612345 | Adam | Piotrowski | adam.piotrowski@email.com | 666777888 |
| 92070754321 | Ewa | Grabowska | ewa.grabowska@email.com | 777888999 |
| 99080876543 | Krzysztof | Pawłowski | krzysztof.pawlowski@email.com | 888999000 |
| 91090932109 | Joanna | Michalska | joanna.michalska@email.com | 999000111 |
| 00100098765 | Marek | Król | marek.krol@email.com | 100111222 |
| 95110145678 | Agnieszka | Jankowska | agnieszka.jankowska@email.com | 211222333 |
| 96120234567 | Robert | Mazur | robert.mazur@email.com | 322333444 |

---

### Reservation Table
**20 records**

| reservation_id | reservation_date | reservation_status | tour_edition_id |
|----------------|------------------|-------------------|-----------------|
| 1 | 2024-05-10 | Paid | 1 |
| 2 | 2024-05-15 | Paid | 1 |
| 3 | 2024-06-01 | Paid | 2 |
| 4 | 2024-06-20 | Processing | 3 |
| 5 | 2024-07-15 | Paid | 4 |
| 6 | 2024-08-01 | Paid | 5 |
| 7 | 2024-08-10 | Unpaid | 5 |
| 8 | 2024-09-05 | Paid | 6 |
| 9 | 2024-10-01 | Processing | 7 |
| 10 | 2024-10-20 | Paid | 8 |
| 11 | 2024-11-01 | Paid | 9 |
| 12 | 2024-11-10 | Paid | 1 |
| 13 | 2024-11-15 | Unpaid | 10 |
| 14 | 2024-12-01 | Paid | 11 |
| 15 | 2024-12-05 | Processing | 12 |
| 16 | 2024-12-10 | Paid | 2 |
| 17 | 2024-12-15 | Paid | 13 |
| 18 | 2024-12-20 | Paid | 14 |
| 19 | 2024-12-25 | Processing | 15 |
| 20 | 2024-12-30 | Paid | 3 |

---

### Payment Table
**18 records** (reservations 4, 7, 9, 13, 15, 19 have partial/no payments)

| payment_id | amount | form_of_payment | date_of_payment | reservation_id |
|------------|--------|-----------------|-----------------|----------------|
| 1 | 2500.00 | Credit Card | 2024-05-12 | 1 |
| 2 | 2500.00 | Transfer | 2024-05-17 | 2 |
| 3 | 3200.00 | Credit Card | 2024-06-03 | 3 |
| 4 | 2800.00 | Transfer | 2024-07-18 | 5 |
| 5 | 1800.00 | Cash | 2024-08-03 | 6 |
| 6 | 5200.00 | Credit Card | 2024-09-07 | 8 |
| 7 | 2100.00 | Transfer | 2024-10-22 | 10 |
| 8 | 3500.00 | Credit Card | 2024-11-03 | 11 |
| 9 | 2500.00 | Transfer | 2024-11-12 | 12 |
| 10 | 2600.00 | Credit Card | 2024-12-03 | 14 |
| 11 | 3200.00 | Credit Card | 2024-12-12 | 16 |
| 12 | 4600.00 | Transfer | 2024-12-17 | 17 |
| 13 | 2900.00 | Cash | 2024-12-22 | 18 |
| 14 | 4500.00 | Credit Card | 2024-12-31 | 20 |
| 15 | 1500.00 | Credit Card | 2024-06-21 | 4 |
| 16 | 1800.00 | Transfer | 2024-08-12 | 7 |
| 17 | 2900.00 | Credit Card | 2024-10-02 | 9 |
| 18 | 1900.00 | Transfer | 2024-12-27 | 19 |

---

### ReservationClient Table (Many-to-Many)
**20 records** - links reservations to clients

| reservation_id | client_pesel |
|----------------|--------------|
| 1 | 95010143210 |
| 2 | 96020287654 |
| 3 | 94030365432 |
| 4 | 97040423456 |
| 5 | 93050598765 |
| 6 | 98060612345 |
| 7 | 92070754321 |
| 8 | 99080876543 |
| 9 | 91090932109 |
| 10 | 00100098765 |
| 11 | 95010143210 |
| 12 | 96020287654 |
| 13 | 98060612345 |
| 14 | 94030365432 |
| 15 | 99080876543 |
| 16 | 00100098765 |
| 17 | 95010143210 |
| 18 | 00100098765 |
| 19 | 95110145678 |
| 20 | 96120234567 |

**Note:** Clients with multiple reservations:
- **95010143210** (Anna Kowalska): reservations 1, 11, 17 → **3 reservations**
- **96020287654** (Jan Nowak): reservations 2, 12 → **2 reservations**
- **00100098765** (Marek Król): reservations 10, 16, 18 → **3 reservations**
- **98060612345** (Adam Piotrowski): reservations 6, 13 → **2 reservations**
- **94030365432** (Maria Wiśniewska): reservations 3, 14 → **2 reservations**
- **99080876543** (Krzysztof Pawłowski): reservations 8, 15 → **2 reservations**

---

### ReservationWorker Table (Many-to-Many)
**20 records** - links reservations to workers who handled them

| reservation_id | worker_pesel |
|----------------|--------------|
| 1 | 85020298765 |
| 2 | 93070734567 |
| 3 | 85020298765 |
| 4 | 93070734567 |
| 5 | 85020298765 |
| 6 | 92030354321 |
| 7 | 93070734567 |
| 8 | 85020298765 |
| 9 | 89080898765 |
| 10 | 93070734567 |
| 11 | 85020298765 |
| 12 | 92030354321 |
| 13 | 93070734567 |
| 14 | 85020298765 |
| 15 | 89080898765 |
| 16 | 93070734567 |
| 17 | 85020298765 |
| 18 | 92030354321 |
| 19 | 93070734567 |
| 20 | 85020298765 |

**Most active workers:**
- **85020298765** (Anna Nowak - Travel Consultant): 8 reservations
- **93070734567** (Michał Zieliński - Travel Consultant): 8 reservations
- **92030354321** (Piotr Wiśniewski - Sales Manager): 3 reservations
- **89080898765** (Magdalena Szymańska - Customer Service Rep): 2 reservations

---

### Marketing Data (CSV File)
**30 records** - sample_marketing_data.csv

| Date | Campaing_Name | Ad-group | Trip_id | Keyword | Impressions | Clicks | CTR | Cost | Conversion Rate |
|------|---------------|----------|---------|---------|-------------|--------|-----|------|-----------------|
| 2024-01-15 | Rodzinne wakacje | First Minute 2024 | 1 | dla dzieci | 45230 | 12450 | 27.53 | 2150.50 | 18.45 |
| 2024-02-20 | Rodzinne wakacje | Last Minute 2024 | 1 | rodzinne wakacje | 38920 | 8830 | 22.69 | 1875.30 | 15.20 |
| 2024-03-10 | Luksusowe podróże | Oferty Specjalne 2024 | 2 | luksusowe podróże | 52100 | 18650 | 35.80 | 3250.75 | 22.10 |
| 2024-03-25 | Egzotyczne destynacje | Nowe Destynacje 2024 | 2 | plaże | 61500 | 25300 | 41.14 | 2890.40 | 19.50 |
| 2024-04-05 | Przygoda i eksploracja | First Minute 2024 | 3 | aktywne wakacje | 48700 | 22100 | 45.38 | 3850.20 | 25.30 |
| 2024-04-20 | Przygoda i eksploracja | All Inclusive 2024 | 3 | sport | 55300 | 28900 | 52.26 | 4125.60 | 28.15 |
| 2024-05-10 | Rodzinne wakacje | Pakiety Wakacyjne 2024 | 4 | rodzinne wakacje | 42800 | 15200 | 35.51 | 2320.45 | 16.80 |
| 2024-05-25 | Rodzinne wakacje | Last Minute 2024 | 4 | dla dzieci | 38600 | 12800 | 33.16 | 2180.90 | 18.25 |
| 2024-06-08 | Wakacje budżetowe | Oferty Specjalne 2024 | 5 | oferty specjalne | 65200 | 31500 | 48.31 | 1950.30 | 21.40 |
| 2024-06-22 | Wakacje dla par | First Minute 2024 | 5 | romantyczne | 28900 | 9650 | 33.39 | 2680.50 | 19.75 |
| 2024-07-15 | Przygoda i eksploracja | Nowe Destynacje 2024 | 6 | egzotyka | 72300 | 35600 | 49.24 | 4520.80 | 26.90 |
| 2024-07-28 | Egzotyczne destynacje | All Inclusive 2024 | 6 | dzika przyroda | 68500 | 29800 | 43.50 | 3875.25 | 23.45 |
| 2024-08-10 | Relaks i wellness | Pakiety Wakacyjne 2024 | 7 | spa | 38700 | 16900 | 43.67 | 2890.60 | 20.30 |
| 2024-08-25 | Luksusowe podróże | Last Minute 2024 | 7 | 5-gwiazdek | 45800 | 19200 | 41.92 | 3650.40 | 24.15 |
| 2024-09-05 | Egzotyczne destynacje | First Minute 2024 | 8 | nieodkryte miejsca | 58200 | 24700 | 42.44 | 3280.90 | 21.80 |
| 2024-09-20 | Rodzinne wakacje | Oferty Specjalne 2024 | 8 | dla dzieci | 51900 | 22400 | 43.16 | 2550.70 | 19.25 |
| 2024-10-12 | Wakacje budżetowe | Nowe Destynacje 2024 | 9 | budżetowe wakacje | 48300 | 20100 | 41.61 | 1680.45 | 17.50 |
| 2024-10-28 | Wakacje dla par | All Inclusive 2024 | 9 | relaks i wellness | 35600 | 14800 | 41.57 | 2890.30 | 20.85 |
| 2024-11-08 | Przygoda i eksploracja | Last Minute 2024 | 10 | ekstremalne | 62800 | 28900 | 46.02 | 4280.50 | 27.40 |
| 2024-11-22 | Przygoda i eksploracja | Pakiety Wakacyjne 2024 | 10 | przygoda | 58700 | 26300 | 44.80 | 3950.80 | 25.60 |
| 2024-05-15 | Relaks i wellness | First Minute 2024 | 7 | joga | 32500 | 13200 | 40.62 | 2150.30 | 18.90 |
| 2024-07-05 | Wakacje dla seniorów | Oferty Specjalne 2024 | 7 | spokojne wakacje | 28900 | 10500 | 36.33 | 1980.70 | 16.45 |
| 2024-08-18 | Wakacje z dziećmi | Nowe Destynacje 2024 | 4 | animacje dla dzieci | 45600 | 18900 | 41.45 | 2320.80 | 20.10 |
| 2024-09-12 | Luksusowe podróże | All Inclusive 2024 | 2 | wysoki standard | 52300 | 21800 | 41.68 | 3720.60 | 23.80 |
| 2024-10-05 | Egzotyczne destynacje | Pakiety Wakacyjne 2024 | 6 | eksploracja | 61200 | 26700 | 43.63 | 3580.40 | 22.95 |
| 2024-11-15 | Rodzinne wakacje | Last Minute 2024 | 1 | rodzinne wakacje | 42100 | 16800 | 39.90 | 2280.50 | 17.85 |
| 2024-04-12 | Wakacje dla par | Nowe Destynacje 2024 | 5 | dla par | 31800 | 11200 | 35.22 | 2450.90 | 18.60 |
| 2024-06-30 | Relaks i wellness | Oferty Specjalne 2024 | 7 | relaks i wellness | 36900 | 15600 | 42.28 | 2680.40 | 19.95 |
| 2024-08-08 | Wakacje budżetowe | First Minute 2024 | 9 | oszczędne podróże | 52700 | 23400 | 44.40 | 1850.60 | 18.20 |
| 2024-09-28 | Przygoda i eksploracja | All Inclusive 2024 | 3 | egzotyka | 59800 | 27100 | 45.32 | 4050.70 | 26.35 |

---

## WAREHOUSE TABLES (HD_warhouse)

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
| 1 | 95010143210 | Nie | GETDATE() | NULL |
| 2 | 96020287654 | Nie | GETDATE() | NULL |
| 3 | 94030365432 | Nie | GETDATE() | NULL |
| 4 | 97040423456 | Tak | GETDATE() | NULL |
| 5 | 93050598765 | Tak | GETDATE() | NULL |
| 6 | 98060612345 | Nie | GETDATE() | NULL |
| 7 | 92070754321 | Tak | GETDATE() | NULL |
| 8 | 99080876543 | Nie | GETDATE() | NULL |
| 9 | 91090932109 | Tak | GETDATE() | NULL |
| 10 | 00100098765 | Nie | GETDATE() | NULL |
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

