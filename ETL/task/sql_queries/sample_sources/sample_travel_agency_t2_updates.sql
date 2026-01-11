-- T2 Snapshot Updates
USE sample_travel_agency_database_2
GO

-- 
-- UPDATE EXISTING RECORDS

-- Update Worker Roles (promotions/role changes)
UPDATE Worker 
SET role = 'Senior Travel Consultant'
WHERE worker_pesel = '85020298765'; -- Anna Nowak promoted

UPDATE Worker 
SET role = 'Senior Sales Director'
WHERE worker_pesel = '92030354321'; -- Piotr Wiśniewski promoted

UPDATE Worker 
SET role = 'Senior Travel Consultant'
WHERE worker_pesel = '93070734567'; -- Michał Zieliński promoted

GO


-- INSERT NEW CLIENTS

INSERT INTO Client (client_pesel, first_name, last_name, email, phone_number) VALUES
('97110187654', 'Tomasz', 'Kozłowski', 'tomasz.kozlowski@email.com', '411222333'),
('98120265432', 'Katarzyna', 'Wójcik', 'katarzyna.wojcik@email.com', '522333444'),
('96010398765', 'Paweł', 'Kamiński', 'pawel.kaminski@email.com', '633444555'),
('99020443210', 'Natalia', 'Zielińska', 'natalia.zielinska@email.com', '744555666'),
('95030576543', 'Bartosz', 'Szymański', 'bartosz.szymanski@email.com', '855666777'),
('00040654321', 'Aleksandra', 'Woźniak', 'aleksandra.wozniak@email.com', '966777888');
GO

-- INSERT NEW RESERVATIONS

SET IDENTITY_INSERT Reservation ON;
INSERT INTO Reservation (reservation_id, reservation_date, reservation_status, tour_edition_id) VALUES
-- Reservations from existing clients
(21, '2025-09-10', 'Paid', 7),        -- '95010143210' Anna Kowalska - Paris
(22, '2025-09-15', 'Paid', 8),        -- '96020287654' Jan Nowak - Greek Islands
(23, '2025-10-05', 'Processing', 9),  -- '94030365432' Maria Wiśniewska - Dubai
(24, '2025-10-20', 'Paid', 10),       -- '93050598765' Zofia Krawczyk - Iceland
(25, '2025-11-01', 'Paid', 7),        -- '98060612345' Adam Piotrowski - Paris
(26, '2025-11-12', 'Unpaid', 11),     -- '92070754321' Ewa Grabowska - Rome
(27, '2025-11-25', 'Paid', 12),       -- '00100098765' Marek Król - Bali

-- Reservations from new clients
(28, '2025-12-01', 'Paid', 13),       -- '97110187654' Tomasz Kozłowski - Swiss Alps
(29, '2025-12-05', 'Processing', 14), -- '98120265432' Katarzyna Wójcik - Kyoto
(30, '2025-12-10', 'Paid', 15),       -- '96010398765' Paweł Kamiński - Barcelona
(31, '2025-12-15', 'Paid', 8),        -- '99020443210' Natalia Zielińska - Greek Islands
(32, '2025-12-20', 'Unpaid', 9),      -- '95030576543' Bartosz Szymański - Dubai
(33, '2025-12-28', 'Paid', 10),       -- '00040654321' Aleksandra Woźniak - Iceland

-- Mixed reservations (more from existing clients)
(34, '2026-01-02', 'Processing', 7),  -- '95110145678' Agnieszka Jankowska - Paris
(35, '2026-01-02', 'Paid', 11);       -- '96120234567' Robert Mazur - Rome
SET IDENTITY_INSERT Reservation OFF;
GO

-- INSERT PAYMENT RECORDS FOR NEW RESERVATIONS

SET IDENTITY_INSERT Payment ON;
INSERT INTO Payment (payment_id, amount, form_of_payment, date_of_payment, reservation_id) VALUES
(19, 2100.00, 'Credit Card', '2025-09-12', 21),
(20, 3500.00, 'Transfer', '2025-09-17', 22),
(21, 2800.00, 'Transfer', '2025-10-22', 24),
(22, 2100.00, 'Credit Card', '2025-11-03', 25),
(23, 3300.00, 'Credit Card', '2025-11-27', 27),
(24, 4600.00, 'Transfer', '2025-12-03', 28),
(25, 1900.00, 'Cash', '2025-12-12', 30),
(26, 3500.00, 'Credit Card', '2025-12-17', 31),
(27, 4800.00, 'Transfer', '2025-12-30', 33),
(28, 2600.00, 'Credit Card', '2026-01-02', 35);
SET IDENTITY_INSERT Payment OFF;
GO

-- INSERT RESERVATION-CLIENT RELATIONSHIPS

INSERT INTO ReservationClient (reservation_id, client_pesel) VALUES
-- Existing clients
(21, '95010143210'),  -- Anna Kowalska
(22, '96020287654'),  -- Jan Nowak
(23, '94030365432'),  -- Maria Wiśniewska
(24, '93050598765'),  -- Zofia Krawczyk
(25, '98060612345'),  -- Adam Piotrowski
(26, '92070754321'),  -- Ewa Grabowska
(27, '00100098765'),  -- Marek Król

-- New clients
(28, '97110187654'),  -- Tomasz Kozłowski
(29, '98120265432'),  -- Katarzyna Wójcik
(30, '96010398765'),  -- Paweł Kamiński
(31, '99020443210'),  -- Natalia Zielińska
(32, '95030576543'),  -- Bartosz Szymański
(33, '00040654321'),  -- Aleksandra Woźniak

-- Existing clients (more reservations)
(34, '95110145678'),  -- Agnieszka Jankowska
(35, '96120234567');  -- Robert Mazur
GO

-- INSERT RESERVATION-WORKER ASSIGNMENTS

INSERT INTO ReservationWorker (reservation_id, worker_pesel) VALUES
-- Using promoted and existing consultants
(21, '85020298765'),  -- Anna Nowak (Senior Travel Consultant)
(22, '93070734567'),  -- Michał Zieliński (Senior Travel Consultant)
(23, '85020298765'),  -- Anna Nowak
(24, '93070734567'),  -- Michał Zieliński
(25, '92030354321'),  -- Piotr Wiśniewski (Sales Director)
(26, '85020298765'),  -- Anna Nowak
(27, '93070734567'),  -- Michał Zieliński
(28, '85020298765'),  -- Anna Nowak
(29, '89080898765'),  -- Magdalena Szymańska
(30, '93070734567'),  -- Michał Zieliński
(31, '85020298765'),  -- Anna Nowak
(32, '92030354321'),  -- Piotr Wiśniewski
(33, '93070734567'),  -- Michał Zieliński
(34, '89080898765'),  -- Magdalena Szymańska
(35, '85020298765');  -- Anna Nowak
GO

PRINT 'T2 Snapshot updates completed successfully!'
PRINT 'Summary:'
PRINT '- Updated 3 worker roles'
PRINT '- Updated 3 client records'
PRINT '- Added 6 new clients'
PRINT '- Added 15 new reservations'
PRINT '- Added 10 new payments'
PRINT '- Linked all new reservations to clients and workers'
GO
