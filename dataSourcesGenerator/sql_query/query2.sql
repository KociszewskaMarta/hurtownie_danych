USE go_explore_travel_agency;
GO

-- reservations made before July 1, 2025
SELECT COUNT(*) AS liczba_rezerwacji
FROM Reservation
WHERE reservation_date <= '2025-07-01';

-- reservations made after July 1, 2025
SELECT COUNT(*) AS liczba_rezerwacji
FROM Reservation
WHERE reservation_date > '2025-07-01';

USE go_explore_travel_agency_t2;
GO

-- reservations made before July 1, 2025
SELECT COUNT(*) AS liczba_rezerwacji
FROM Reservation
WHERE reservation_date <= '2025-07-01';

-- reservations made after July 1, 2025
SELECT COUNT(*) AS liczba_rezerwacji
FROM Reservation
WHERE reservation_date > '2025-07-01';