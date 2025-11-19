--INSERTS

INSERT INTO Wycieczka_D (nazwa_wycieczki, destynacja, typ)
VALUES
('Wakacje w Hiszpanii', 'Hiszpania', 'relaks'),
('Zwiedzanie Rzymu', 'Włochy', 'city-break'),
('Rodzinne Tatry', 'Polska', 'rodzinne'),
('Aktywny weekend w Alpach', 'Szwajcaria', 'aktywnie');

INSERT INTO Data_D (rok, pora_roku, miesiac, dzien)
VALUES
('2025', 'lato', '07', '15'),
('2025', 'lato', '07', '16'),
('2025', 'wiosna', '04', '10'),
('2025', 'zima', '01', '02');

INSERT INTO Klient_D (pesel_klienta, czy_nowy, data_wpisania, data_wygasniecia)
VALUES
(90010112345, 1, '2024-03-01', NULL),
(85050567890, 0, '2022-10-12', NULL),
(92031255555, 1, '2024-11-20', NULL);

INSERT INTO Slowo_kluczowe_D (slowo_kluczowe)
VALUES
('wakacje Hiszpania'),
('last minute'),
('tatry rodzinne'),
('city break rzym');

INSERT INTO Nazwa_kampanii_D (nazwa_kampanii)
VALUES
('Lato 2025 Hiszpania'),
('Weekend Rzym'),
('Tatry Rodzinna Majówka'),
('Alpy Aktywnie 2025');

INSERT INTO Rezerwacja_F (id_wycieczki, id_klienta, id_daty, oplacona, kwota_transakcji, cena_turnusu)
VALUES
(1, 1, 1, 1, 4200, 4200), -- Hiszpania, klient 1
(2, 2, 3, 0, 1800, 1800), -- Rzym, klient 2
(3, 3, 4, 1, 1500, 1500); -- Tatry, klient 3

INSERT INTO Kampania_F 
(id_wycieczki, id_daty, id_slowa_kluczowego, id_nazwy_kampanii, 
 wspolczynnik_konwersji, koszt_kampanii, liczba_klikniec, koszt_na_klikniecie)
VALUES
(1, 1, 1, 1, 0.05, 3000, 1500, 2),
(2, 3, 4, 2, 0.04, 1500, 800, 1),
(3, 4, 3, 3, 0.03, 900, 400, 2),
(4, 2, 2, 4, 0.06, 2500, 1200, 2);


