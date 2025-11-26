--DIMENSIONS

CREATE TABLE Wycieczka_D
(
	id_wycieczki INTEGER IDENTITY(1,1) PRIMARY KEY,
	nazwa_wycieczki NVARCHAR(255),
	destynacja NVARCHAR(255),
	typ NVARCHAR(100)
);

CREATE TABLE Data_D
(
	id_daty INTEGER IDENTITY(1,1) PRIMARY KEY,
	rok NVARCHAR(4),
	pora_roku NVARCHAR(20),
	miesiac NVARCHAR(10),
	dzien NVARCHAR(10)
)

CREATE TABLE Klient_D
(
	id_klienta INTEGER IDENTITY(1,1) PRIMARY KEY,
	pesel_klienta BIGINT,
	czy_nowy BIT,
	data_wpisania DATE,
	data_wygasniecia DATE
);

CREATE TABLE Slowo_kluczowe_D
(
	id_slowa_kluczowego INTEGER IDENTITY(1,1) PRIMARY KEY,
	slowo_kluczowe NVARCHAR(255)
);

CREATE TABLE Nazwa_kampanii_D
(
	id_nazwy_kampanii INTEGER IDENTITY(1,1) PRIMARY KEY,
	nazwa_kampanii NVARCHAR(255)
);

--FACTS

CREATE TABLE Rezerwacja_F
(
	id_wycieczki INTEGER NOT NULL,
	id_klienta INTEGER NOT NULL,
	id_daty INTEGER NOT NULL,
	oplacona BIT,
	kwota_transakcji INT,
	cena_turnusu INT,

	CONSTRAINT id_rezerwacji PRIMARY KEY (
		id_wycieczki,
		id_klienta,
		id_daty
	),

	FOREIGN KEY (id_wycieczki) REFERENCES Wycieczka_D(id_wycieczki),
	FOREIGN KEY (id_klienta) REFERENCES Klient_D(id_klienta),
	FOREIGN KEY (id_daty) REFERENCES Data_D(id_daty)
);

CREATE TABLE Kampania_F
(
	id_wycieczki INTEGER NOT NULL,
	id_daty INTEGER NOT NULL,
	id_slowa_kluczowego INTEGER NOT NULL,
	id_nazwy_kampanii INTEGER NOT NULL,
	wspolczynnik_konwersji DECIMAL(5,2),
	koszt_kampanii INT,
	liczba_klikniec INT,
	koszt_na_klikniecie INT,

	CONSTRAINT id_kampanii PRIMARY KEY (
		id_wycieczki,
		id_daty,
		id_slowa_kluczowego,
		id_nazwy_kampanii
	),

	FOREIGN KEY (id_wycieczki) REFERENCES Wycieczka_D(id_wycieczki),
	FOREIGN KEY (id_daty) REFERENCES Data_D(id_daty),
	FOREIGN KEY (id_slowa_kluczowego) REFERENCES Slowo_kluczowe_D(id_slowa_kluczowego),
	FOREIGN KEY (id_nazwy_kampanii) REFERENCES Nazwa_kampanii_D(id_nazwy_kampanii)
);