/*
TEST CASE 1 and TEST CASE 2
- Load T1 snapshot to the source db/file - `create_sample_database`, `sample_travel_agency_full`
- Run ETL - all loading scripts in correct sequence
- Check if the number of rows in fact tables corresponds to the number of related rows in the sources 
- Run ETL again and check if rows in the fact table were not duplicated (there is still the same number of facts and corresponding source rows)

- Load T2 snapshot to the source db/file - `sample_travel_agency_t2_updates`
- Run ETL all loading scripts in correct sequence
- Check if the number of rows in fact tables corresponds to the number of related rows in the sources
*/ 
use sample_travel_agency_database
go

-- count number of clients
SELECT COUNT(*) AS client_count_source FROM Client;
GO

-- count number of reservations
SELECT COUNT(*) AS reservation_count_source FROM Reservation;
GO

use sample_travel_agency_database_2
GO

-- count number of clients
SELECT COUNT(*) AS client_count_source_2 FROM Client;
GO

-- count number of reservations
SELECT COUNT(*) AS reservation_count_source_2 FROM Reservation;
GO

use sample_warehouse
GO
-- count number of dim clients
SELECT COUNT(*) AS client_count_warehouse FROM Klient_D;
GO

-- count number of fact reservations
SELECT COUNT(*) AS reservation_count_warehouse FROM Rezerwacja_F;
GO
