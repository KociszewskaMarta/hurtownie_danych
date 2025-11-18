CREATE DATABASE data_warehouse_design
GO

USE data_warehouse_design
GO

CREATE TABLE Klient_d (
    pesel_klienta VARCHAR(11) PRIMARY KEY,
    data_pierwszej_rezerwacji DATE NOT NULL
);
CREATE TABLE Slowo_kluczowe_d (
    id_slowo_kluczowe INT IDENTITY(1,1) PRIMARY KEY,
    slowo_kluczowe VARCHAR(255) NOT NULL
);
CREATE TABLE Wycieczka_d(
    id_wycieczka INT IDENTITY(1,1) PRIMARY KEY,
    nazwa_wycieczki VARCHAR(255) NOT NULL,
    destynacja VARCHAR(255) NOT NULL,
    typ VARCHAR(100) NOT NULL 
        CHECK (typ IN ('Relaks', 'aktywnie', 'rodzinnie', 'city-break'))
);
CREATE TABLE Turnus_d(
    id_turnus INT IDENTITY(1,1) PRIMARY KEY,
    id_wycieczka INT NOT NULL REFERENCES Wycieczka_d(id_wycieczka),
    cena DECIMAL(10,2) NOT NULL
);
CREATE TABLE Data_d(
    id_data INT IDENTITY(1,1) PRIMARY KEY,
    rok VARCHAR(4) NOT NULL,
    pora_roku VARCHAR(20) NOT NULL
        CHECK (pora_roku IN ('wiosna', 'lato', 'jesien', 'zima')),
    miesiac VARCHAR(20) NOT NULL,
    dzien VARCHAR(20) NOT NULL
);
CREATE TABLE Rezerwacja_f(
    id_rezerwacja INT IDENTITY(1,1) PRIMARY KEY,
    id_turnus INT NOT NULL REFERENCES Turnus_d(id_turnus),
    pesel_klienta VARCHAR(11) NOT NULL REFERENCES Klient_d(pesel_klienta),
    id_data INT NOT NULL REFERENCES Data_d(id_data),
    oplacona BIT NOT NULL,
    kwota DECIMAL(10,2) NOT NULL
);
CREATE TABLE Kampania_f(
    id_kampania INT IDENTITY(1,1) PRIMARY KEY,
    id_data INT NOT NULL REFERENCES Data_d(id_data),
    id_wycieczka INT NOT NULL REFERENCES Wycieczka_d(id_wycieczka),
    id_slowo_kluczowe INT NOT NULL REFERENCES Slowo_kluczowe_d(id_slowo_kluczowe),
    wyswietlenia INT NOT NULL,
    klikniecia INT NOT NULL,
    wspolczynnik_klikalnosci DECIMAL(5,2) NOT NULL
        CHECK (wspolczynnik_klikalnosci BETWEEN 0 AND 100),
    koszt_pozyskania_klienta DECIMAL(10,2) NOT NULL,
    wspolczynnik_konwersji DECIMAL(5,2) NOT NULL
        CHECK (wspolczynnik_konwersji BETWEEN 0 AND 100)
);