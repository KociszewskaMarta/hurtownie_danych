USE sample_travel_agency_database_2
GO

SET IDENTITY_INSERT Tour ON;
INSERT INTO Tour (tour_id, name, destination, tour_type, attractions) VALUES
(1, 'Historical Landmarks Journey', 'Rome, Italy', 'Relax', 'Ancient Ruins, Museums, Local Markets'),
(2, 'Tropical Paradise Getaway', 'Bali, Indonesia', 'Family', 'Beaches, Coral Reefs, Tropical Forests'),
(3, 'Mountain Adventure Expedition', 'Swiss Alps, Switzerland', 'Active', 'Hiking Trails, Mountain Peaks, Glaciers'),
(4, 'Cultural Heritage Tour', 'Kyoto, Japan', 'Family', 'Temples, Gardens, Cultural Festivals'),
(5, 'City Explorer Package', 'Barcelona, Spain', 'City-break', 'Architecture, Beaches, Nightlife'),
(6, 'Wildlife Safari Experience', 'Serengeti, Tanzania', 'Active', 'Safari Drives, Wildlife Viewing, National Parks'),
(7, 'Art and Architecture Walk', 'Paris, France', 'Relax', 'Art Galleries, Museums, Historical Buildings'),
(8, 'Island Hopping Adventure', 'Greek Islands', 'Family', 'Island Tours, Beaches, Local Cuisine'),
(9, 'Desert Discovery Tour', 'Dubai, UAE', 'City-break', 'Desert Safari, Modern Architecture, Shopping'),
(10, 'Northern Lights Quest', 'Iceland', 'Active', 'Glaciers, Waterfalls, Northern Lights Viewing');
SET IDENTITY_INSERT Tour OFF;
GO

SET IDENTITY_INSERT TourEdition ON;
INSERT INTO TourEdition (tour_edition_id, start_date, end_date, price, available_slots, tour_id) VALUES
(1, '2024-06-15', '2024-06-26', 2500.00, 20, 1),
(2, '2024-07-10', '2024-07-20', 3200.00, 15, 2),
(3, '2024-08-05', '2024-08-15', 4500.00, 12, 3),
(4, '2024-09-01', '2024-09-12', 2800.00, 18, 4),
(5, '2024-10-15', '2024-10-22', 1800.00, 25, 5),
(6, '2024-11-10', '2024-11-20', 5200.00, 10, 6),
(7, '2025-01-15', '2025-01-22', 2100.00, 20, 7),
(8, '2025-02-20', '2025-03-02', 3500.00, 16, 8),
(9, '2025-03-10', '2025-03-17', 2900.00, 22, 9),
(10, '2025-04-05', '2025-04-15', 4800.00, 14, 10),
(11, '2024-12-01', '2024-12-08', 2600.00, 18, 1),
(12, '2025-05-20', '2025-05-30', 3300.00, 15, 2),
(13, '2025-06-15', '2025-06-25', 4600.00, 10, 3),
(14, '2025-07-10', '2025-07-21', 2900.00, 20, 4),
(15, '2025-08-05', '2025-08-12', 1900.00, 25, 5);
SET IDENTITY_INSERT TourEdition OFF;
GO

INSERT INTO Worker (worker_pesel, first_name, last_name, email, phone_number, role) VALUES
('90010112345', 'Jan', 'Kowalski', 'jan.kowalski@goexplore.com', '123456789', 'Manager'),
('85020298765', 'Anna', 'Nowak', 'anna.nowak@goexplore.com', '234567890', 'Travel Consultant'),
('92030354321', 'Piotr', 'Wiśniewski', 'piotr.wisniewski@goexplore.com', '345678901', 'Sales Manager'),
('88040467890', 'Maria', 'Wójcik', 'maria.wojcik@goexplore.com', '456789012', 'Marketing Specialist'),
('91050523456', 'Tomasz', 'Kamiński', 'tomasz.kaminski@goexplore.com', '567890123', 'Operations Manager'),
('87060609876', 'Katarzyna', 'Lewandowska', 'katarzyna.lewandowska@goexplore.com', '678901234', 'Finance Officer'),
('93070734567', 'Michał', 'Zieliński', 'michal.zielinski@goexplore.com', '789012345', 'Travel Consultant'),
('89080898765', 'Magdalena', 'Szymańska', 'magdalena.szymanska@goexplore.com', '890123456', 'Customer Service Representative');
GO

INSERT INTO Client (client_pesel, first_name, last_name, email, phone_number) VALUES
('95010143210', 'Anna', 'Kowalska', 'anna.kowalska@email.com', '111222333'),
('96020287654', 'Jan', 'Nowak', 'jan.nowak@email.com', '222333444'),
('94030365432', 'Maria', 'Wiśniewska', 'maria.wisniewska@email.com', '333444555'),
('97040423456', 'Piotr', 'Dąbrowski', 'piotr.dabrowski@email.com', '444555666'),
('93050598765', 'Zofia', 'Krawczyk', 'zofia.krawczyk@email.com', '555666777'),
('98060612345', 'Adam', 'Piotrowski', 'adam.piotrowski@email.com', '666777888'),
('92070754321', 'Ewa', 'Grabowska', 'ewa.grabowska@email.com', '777888999'),
('99080876543', 'Krzysztof', 'Pawłowski', 'krzysztof.pawlowski@email.com', '888999000'),
('91090932109', 'Joanna', 'Michalska', 'joanna.michalska@email.com', '999000111'),
('00100098765', 'Marek', 'Król', 'marek.krol@email.com', '100111222'),
('95110145678', 'Agnieszka', 'Jankowska', 'agnieszka.jankowska@email.com', '211222333'),
('96120234567', 'Robert', 'Mazur', 'robert.mazur@email.com', '322333444');
GO

SET IDENTITY_INSERT Reservation ON;
INSERT INTO Reservation (reservation_id, reservation_date, reservation_status, tour_edition_id) VALUES
(1, '2024-05-10', 'Paid', 1),
(2, '2024-05-15', 'Paid', 1),
(3, '2024-06-01', 'Paid', 2),
(4, '2024-06-20', 'Processing', 3),
(5, '2024-07-15', 'Paid', 4),
(6, '2024-08-01', 'Paid', 5),
(7, '2024-08-10', 'Unpaid', 5),
(8, '2024-09-05', 'Paid', 6),
(9, '2024-10-01', 'Processing', 7),
(10, '2024-10-20', 'Paid', 8),
(11, '2024-11-01', 'Paid', 9),
(12, '2024-11-10', 'Paid', 1),
(13, '2024-11-15', 'Unpaid', 10),
(14, '2024-12-01', 'Paid', 11),
(15, '2024-12-05', 'Processing', 12),
(16, '2024-12-10', 'Paid', 2),
(17, '2024-12-15', 'Paid', 13),
(18, '2024-12-20', 'Paid', 14),
(19, '2024-12-25', 'Processing', 15),
(20, '2024-12-30', 'Paid', 3);
SET IDENTITY_INSERT Reservation OFF;
GO

SET IDENTITY_INSERT Payment ON;
INSERT INTO Payment (payment_id, amount, form_of_payment, date_of_payment, reservation_id) VALUES
(1, 2500.00, 'Credit Card', '2024-05-12', 1),
(2, 2500.00, 'Transfer', '2024-05-17', 2),
(3, 3200.00, 'Credit Card', '2024-06-03', 3),
(4, 2800.00, 'Transfer', '2024-07-18', 5),
(5, 1800.00, 'Cash', '2024-08-03', 6),
(6, 5200.00, 'Credit Card', '2024-09-07', 8),
(7, 2100.00, 'Transfer', '2024-10-22', 10),
(8, 3500.00, 'Credit Card', '2024-11-03', 11),
(9, 2500.00, 'Transfer', '2024-11-12', 12),
(10, 2600.00, 'Credit Card', '2024-12-03', 14),
(11, 3200.00, 'Credit Card', '2024-12-12', 16),
(12, 4600.00, 'Transfer', '2024-12-17', 17),
(13, 2900.00, 'Cash', '2024-12-22', 18),
(14, 4500.00, 'Credit Card', '2024-12-31', 20),
(15, 1500.00, 'Credit Card', '2024-06-21', 4),
(16, 1800.00, 'Transfer', '2024-08-12', 7),
(17, 2900.00, 'Credit Card', '2024-10-02', 9),
(18, 1900.00, 'Transfer', '2024-12-27', 19);
SET IDENTITY_INSERT Payment OFF;
GO

INSERT INTO ReservationClient (reservation_id, client_pesel) VALUES
(1, '95010143210'),
(2, '96020287654'),
(3, '94030365432'),
(4, '97040423456'),
(5, '93050598765'),
(6, '98060612345'),
(7, '92070754321'),
(8, '99080876543'),
(9, '91090932109'),
(10, '00100098765'),
(11, '95010143210'),
(12, '96020287654'),
(13, '98060612345'),
(14, '94030365432'),
(15, '99080876543'),
(16, '00100098765'),
(17, '95010143210'),
(18, '00100098765'),
(19, '95110145678'),
(20, '96120234567');
GO

INSERT INTO ReservationWorker (reservation_id, worker_pesel) VALUES
(1, '85020298765'),
(2, '93070734567'),
(3, '85020298765'),
(4, '93070734567'),
(5, '85020298765'),
(6, '92030354321'),
(7, '93070734567'),
(8, '85020298765'),
(9, '89080898765'),
(10, '93070734567'),
(11, '85020298765'),
(12, '92030354321'),
(13, '93070734567'),
(14, '85020298765'),
(15, '89080898765'),
(16, '93070734567'),
(17, '85020298765'),
(18, '92030354321'),
(19, '93070734567'),
(20, '85020298765');
GO

