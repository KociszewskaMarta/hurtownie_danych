USE sample_travel_agency_database_2;
GO

-- Add a new client if needed
INSERT INTO Client (client_pesel, first_name, last_name, email, phone_number)
VALUES ('UNKNOWN', 'Test', 'UnknownDate', 'test.unknown@email.com', '000000000');
GO

-- Add a new reservation with a date that does NOT exist in Data_D
INSERT INTO Reservation (reservation_date, reservation_status, tour_edition_id)
VALUES ('2099-01-01', 'Paid', 1); -- 2099-01-01 is outside your loaded date range
GO

-- Get the new reservation_id
DECLARE @new_res_id INT = SCOPE_IDENTITY();

-- Link the reservation to the client
INSERT INTO ReservationClient (reservation_id, client_pesel)
VALUES (@new_res_id, '99999999999');
GO
