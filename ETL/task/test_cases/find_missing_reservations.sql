
-- Print all reservation IDs from the source
USE sample_travel_agency_database_2;
GO
SELECT reservation_id FROM Reservation;
GO

-- Print all reservation composite keys from the warehouse
USE sample_warehouse;
GO
SELECT id_wycieczki, id_klienta, id_daty, id_nazwy_kampanii, id_junk FROM Rezerwacja_F;
GO

-- Print all client pesels for each reservation in the source
USE sample_travel_agency_database_2;
GO
SELECT rc.reservation_id, rc.client_pesel FROM ReservationClient rc;
GO

-- Print all client pesels in the warehouse dimension
USE sample_warehouse;
GO
SELECT pesel_klienta FROM Klient_D;
GO

-- Print all tour IDs for each reservation in the source
USE sample_travel_agency_database_2;
GO
SELECT r.reservation_id, te.tour_id FROM Reservation r JOIN TourEdition te ON r.tour_edition_id = te.tour_edition_id;
GO

-- Print all tour IDs in the warehouse dimension
USE sample_warehouse;
GO
SELECT id_wycieczki FROM Wycieczka_D;
GO

-- Print all reservation dates in the source
USE sample_travel_agency_database_2;
GO
SELECT reservation_id, reservation_date FROM Reservation;
GO

-- Print all dates in the warehouse dimension
USE sample_warehouse;
GO
SELECT id_daty, rok, miesiac, dzien FROM Data_D;
GO

-- Step 2: For each missing reservation, check if all dimension values exist in the warehouse
-- Example for client dimension:
-- For each missing reservation, get client pesel from source and check if it exists in Klient_D

USE sample_travel_agency_database_2;
GO
-- Create and populate global temp table with reservation IDs from the source
SELECT reservation_id
INTO ##SourceReservations
FROM Reservation;
GO
SELECT rc.reservation_id, rc.client_pesel
FROM ReservationClient rc
WHERE rc.reservation_id IN (SELECT reservation_id FROM ##SourceReservations);


-- Then, in warehouse, check if pesel exists:
-- USE sample_warehouse;
-- SELECT pesel_klienta FROM Klient_D WHERE pesel_klienta IN (SELECT client_pesel FROM ReservationClient WHERE reservation_id IN (SELECT reservation_id FROM ##SourceReservations));

-- Repeat similar checks for tour, date, and other dimensions as needed.


-- Cleanup temp tables
DROP TABLE IF EXISTS ##SourceReservations;
-- DROP TABLE IF EXISTS ##WarehouseReservations;
DROP TABLE IF EXISTS #MissingReservations;
USE sample_travel_agency_database_2;
GO
DROP TABLE IF EXISTS #SourceReservations;
