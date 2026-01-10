USE sample_travel_agency_database_2;
GO

-- Add a new reservation with a date that does NOT exist in Data_D
INSERT INTO Reservation (reservation_date, reservation_status, tour_edition_id)
VALUES ('2098-01-01', 'Unpaid', 1); -- 2098-01-01 is outside your loaded date range
GO

-- Add a new reservation referencing a client that does NOT exist in Klient_D
DECLARE @new_res_id INT;

INSERT INTO Reservation (reservation_date, reservation_status, tour_edition_id)
VALUES ('2024-01-01', 'Unpaid', 1);

SET @new_res_id = SCOPE_IDENTITY();

INSERT INTO Client (client_pesel, first_name, last_name, email, phone_number)
VALUES ('00000000000', 'Unknown', 'Unknown', 'unknown@email.com', '000000000');

INSERT INTO ReservationClient (reservation_id, client_pesel)
VALUES (@new_res_id, '00000000000'); -- Pesel that does not exist in Klient_D
GO

