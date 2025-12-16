-- Clear all data from sample_client_reservation (source database)
USE sample_client_reservation;
GO

-- Option 1: Clear data only (keeps table structure)
DELETE FROM ReservationClient;
DELETE FROM Reservation;
DELETE FROM Client;
GO

PRINT 'sample_travel_agency data cleared successfully';
GO

-- Option 2: Drop tables completely (uncomment if you want to drop tables)
DROP TABLE IF EXISTS ReservationClient;
DROP TABLE IF EXISTS Reservation;
DROP TABLE IF EXISTS Client;
GO
PRINT 'sample_travel_agency tables dropped successfully';
GO

-- Clear all data from SCD_test (warehouse database)
USE SCD_test;
GO

-- Option 1: Clear data only (keeps table structure)
DELETE FROM Klient_D;
GO

PRINT 'SCD_test data cleared successfully';
GO

-- Option 2: Drop table completely (uncomment if you want to drop table)
DROP TABLE IF EXISTS Klient_D;
GO
PRINT 'SCD_test tables dropped successfully';
GO
