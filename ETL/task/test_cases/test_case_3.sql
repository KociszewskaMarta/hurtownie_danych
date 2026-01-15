/*
TEST CASE 3 
- Load T2 snapshot to the source db/file.
- Run ETL.
- Check if the new row is added to the SCD2 dimension.
- Check if the old row is updated (experiation date is added or isCurrent is set to 0).
- Run ETL once again and check if there was no change in the DW.
*/
USE sample_travel_agency_database_2
GO

select * from Client where client_pesel in ('45678901234', '56789012345', '00040654321')
GO

use sample_warehouse
GO

select * from Klient_D where pesel_klienta in ('45678901234', '56789012345', '00040654321')
Go

USE sample_travel_agency_database_2
GO

-- new client with one reservation should be marked as new
INSERT INTO Client (client_pesel, first_name, last_name, email, phone_number) VALUES
('45678901234', 'Piotr', 'Nowicki', 'piotr.nowicki@email.com', '456789012');
GO

-- new client with multiple reservations should NOT be marked as new
INSERT INTO Client (client_pesel, first_name, last_name, email, phone_number) VALUES
('56789012345', 'Katarzyna', 'Lewandowska', 'katarzyna.lewandowska@email.com', '567890123');
GO

-- reservation (NEW)
INSERT INTO Reservation (reservation_date, reservation_status, tour_edition_id) VALUES ('2025-05-10', 'Paid', 1);
DECLARE @reservation_id1 INT = SCOPE_IDENTITY();
INSERT INTO ReservationClient (reservation_id, client_pesel) VALUES (@reservation_id1, '45678901234');
GO

-- first reservation
INSERT INTO Reservation (reservation_date, reservation_status, tour_edition_id) VALUES ('2025-06-15', 'Paid', 2);
DECLARE @reservation_id2 INT = SCOPE_IDENTITY();
INSERT INTO ReservationClient (reservation_id, client_pesel) VALUES (@reservation_id2, '56789012345');
GO

-- second reservation (NOT NEW)
INSERT INTO Reservation (reservation_date, reservation_status, tour_edition_id) VALUES ('2025-07-20', 'Paid', 2);
DECLARE @reservation_id3 INT = SCOPE_IDENTITY();
INSERT INTO ReservationClient (reservation_id, client_pesel) VALUES (@reservation_id3, '56789012345');
GO

-- second reservation (was NEW, now NOT NEW - SCD2 change)
INSERT INTO Reservation (reservation_date, reservation_status, tour_edition_id) VALUES ('2025-08-25', 'Paid', 3);
DECLARE @reservation_id4 INT = SCOPE_IDENTITY();
INSERT INTO ReservationClient (reservation_id, client_pesel) VALUES (@reservation_id4, '00040654321');
GO

USE sample_travel_agency_database_2
GO

select * from Client where client_pesel in ('45678901234', '56789012345', '00040654321')
GO

use sample_warehouse
GO

select * from Klient_D where pesel_klienta in ('45678901234', '56789012345', '00040654321')
Go

