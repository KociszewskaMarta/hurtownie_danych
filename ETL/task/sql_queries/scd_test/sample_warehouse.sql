-- Sample warehouse database for testing client ETL
-- CREATE DATABASE SCD_test
-- GO

USE SCD_test
GO

-- Create Klient_D dimension table (SCD Type 2)
CREATE TABLE Klient_D
(
	id_klienta INTEGER IDENTITY(1,1) PRIMARY KEY,
	pesel_klienta NVARCHAR(11),
	czy_nowy NVARCHAR(3),
	data_wpisania DATE,
	data_wygasniecia DATE
);
GO