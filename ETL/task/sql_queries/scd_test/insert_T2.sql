USE sample_travel_agency
GO

-- T2: Add new clients and update existing client Jan

-- 1. Add new client with ONE reservation (should be marked as NEW)
INSERT INTO Client (client_pesel, first_name, last_name, email, phone_number) VALUES
('45678901234', 'Piotr', 'Nowicki', 'piotr.nowicki@email.com', '456789012');
GO

-- 2. Add new client with MULTIPLE reservations (should NOT be marked as NEW)
INSERT INTO Client (client_pesel, first_name, last_name, email, phone_number) VALUES
('56789012345', 'Katarzyna', 'Lewandowska', 'katarzyna.lewandowska@email.com', '567890123');
GO

-- 3. Add new reservations
INSERT INTO Reservation (reservation_date) VALUES
('2025-05-10'),  -- reservation_id will be 5
('2025-06-15'),  -- reservation_id will be 6
('2025-07-20'),  -- reservation_id will be 7
('2025-08-25');  -- reservation_id will be 8 (second reservation for Jan)
GO

-- 4. Link reservations to clients
INSERT INTO ReservationClient (reservation_id, client_pesel) VALUES
(5, '45678901234'),  -- Piotr: 1 reservation (NEW)
(6, '56789012345'),  -- Katarzyna: first reservation
(7, '56789012345'),  -- Katarzyna: second reservation (NOT NEW)
(8, '23456789012');  -- Jan: second reservation (was NEW, now NOT NEW - SCD2 change!)
GO

-- Summary after T2:
-- Anna: 2 reservations → NOT NEW (unchanged)
-- Jan: 2 reservations → NOT NEW (changed from NEW to NOT NEW) ← SCD2 should create new version
-- Maria: 1 reservation → NEW (unchanged)
-- Piotr: 1 reservation → NEW (new client)
-- Katarzyna: 2 reservations → NOT NEW (new client)