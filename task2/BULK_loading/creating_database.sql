CREATE DATABASE go_explore_travel_agency /* exams */
GO

USE go_explore_travel_agency
GO

CREATE TABLE Tour /* wycieczka */
(
    tour_id INT IDENTITY(1,1) PRIMARY KEY, /* Generates primery key, from 1 with step 1 */
	name VARCHAR(255) NOT NULL,
	destination VARCHAR(255) NOT NULL,
	tour_type NVARCHAR(20) 
	    CHECK (tour_type IN ('Relax', 'Active', 'Family', 'City-break')), /* TODO : set different acceptable values or remove this constraint */
	attractions VARCHAR(255) NOT NULL
)
GO

CREATE TABLE TourEdition /* turnus */
(
    tour_edition_id INT IDENTITY(1,1) PRIMARY KEY, /* Generates primery key, from 1 with step 1 */
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	price DECIMAL(10,2) NOT NULL,
	available_slots INT NOT NULL 
		CHECK (available_slots >= 0),
	tour_id INT NOT NULL,
	FOREIGN KEY (tour_id) REFERENCES Tour(tour_id) /* relacja 1:n wycieczka - turnus */
)
GO

CREATE TABLE Worker /* pracownik */
(
	worker_pesel CHAR(11) PRIMARY KEY, /* Generates primery key, from 1 with step 1 */
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	email NVARCHAR(255) NOT NULL,
	phone_number CHAR(9) NOT NULL,
	role VARCHAR(100) NOT NULL
)
GO

CREATE TABLE Client /* klient */
(
	client_pesel CHAR(11) PRIMARY KEY, /* Generates primery key, from 1 with step 1 */
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	email NVARCHAR(255) NOT NULL,
	phone_number CHAR(9) NOT NULL
)
GO

CREATE TABLE Reservation /* rezerwacja */
(
	reservation_id INT IDENTITY(1,1) PRIMARY KEY, /* Generates primery key, from 1 with step 1 */
	reservation_date DATE NOT NULL,
	reservation_status NVARCHAR(20) 
	    CHECK (reservation_status IN ('Paid', 'Unpaid', 'Processing')),
	tour_edition_id INT NOT NULL,
	FOREIGN KEY (tour_edition_id) REFERENCES TourEdition(tour_edition_id),
)
GO

CREATE TABLE Payment /* platnosc */
(
	payment_id INT IDENTITY(1,1) PRIMARY KEY, /* Generates primery key, from 1 with step 1 */
	amount DECIMAL(10, 2) NOT NULL 
		CHECK (amount > 0),
	form_of_payment NVARCHAR(50) NOT NULL	
		CHECK (form_of_payment IN ('Credit Card', 'Transfer', 'Cash')),
	date_of_payment DATE NOT NULL,
	reservation_id INT NOT NULL,
	FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id)
)
GO

CREATE TABLE ReservationClient (
    reservation_id INT NOT NULL,
    client_pesel CHAR(11) NOT NULL,
    PRIMARY KEY (reservation_id, client_pesel),
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),
    FOREIGN KEY (client_pesel) REFERENCES Client(client_pesel)
);
GO

CREATE TABLE ReservationWorker (
	reservation_id INT NOT NULL,
	worker_pesel CHAR(11) NOT NULL,
	PRIMARY KEY (reservation_id, worker_pesel),
	FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),
	FOREIGN KEY (worker_pesel) REFERENCES Worker(worker_pesel)
);
GO