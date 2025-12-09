-- Sample database for testing Client and Reservation logic
-- CREATE DATABASE sample_travel_agency
-- GO

USE sample_travel_agency
GO

-- Create Client table
CREATE TABLE Client (
    client_pesel CHAR(11) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL,
    phone_number CHAR(9) NOT NULL
);
GO

-- Create Reservation table
CREATE TABLE Reservation (
    reservation_id INT IDENTITY(1,1) PRIMARY KEY,
    reservation_date DATE NOT NULL
);
GO

-- Create ReservationClient table
CREATE TABLE ReservationClient (
    reservation_id INT NOT NULL,
    client_pesel CHAR(11) NOT NULL,
    PRIMARY KEY (reservation_id, client_pesel),
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),
    FOREIGN KEY (client_pesel) REFERENCES Client(client_pesel)
);
GO

-- Insert sample clients
INSERT INTO Client (client_pesel, first_name, last_name, email, phone_number) VALUES
('12345678901', 'Anna', 'Kowalska', 'anna.kowalska@email.com', '123456789'),
('23456789012', 'Jan', 'Nowak', 'jan.nowak@email.com', '234567890'),
('34567890123', 'Maria', 'Wiśniewska', 'maria.wisniewska@email.com', '345678901');
GO

-- Insert sample reservations
INSERT INTO Reservation (reservation_date) VALUES
('2025-01-10'),
('2025-02-15'),
('2025-03-20'),
('2025-04-05');
GO

-- Link clients to reservations
-- Anna: 2 reservations, Jan: 1 reservation, Maria: 1 reservation
INSERT INTO ReservationClient (reservation_id, client_pesel) VALUES
(1, '12345678901'),
(2, '12345678901'),
(3, '23456789012'),
(4, '34567890123');
GO

-- Now Anna is NOT new (2 reservations), Jan and Maria are new (1 reservation each)
-- You can use this database to test your ETL logic.
