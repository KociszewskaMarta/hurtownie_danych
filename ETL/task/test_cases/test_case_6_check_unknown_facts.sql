-- Check if facts in DW reference the 'UNKNOWN' row in any dimension
USE sample_warehouse;
GO

-- Rezerwacja_F: Check for facts referencing UNKNOWN date
SELECT f.*
FROM Rezerwacja_F f
JOIN Data_D d ON f.id_daty = d.id_daty
WHERE d.rok = 'UNK' AND d.miesiac = 'UNK' AND d.dzien = 'UNK';

SELECT * FROM Data_D WHERE id_daty = 48225

-- Rezerwacja_F: Check for facts referencing UNKNOWN client
SELECT f.*
FROM Rezerwacja_F f
JOIN Klient_D k ON f.id_klienta = k.id_klienta
WHERE k.pesel_klienta = 'UNKNOWN';

SELECT * FROM Klient_D WHERE id_klienta =  219

-- Rezerwacja_F: Check for facts referencing UNKNOWN trip
SELECT f.*
FROM Rezerwacja_F f
JOIN Wycieczka_D w ON f.id_wycieczki = w.id_wycieczki
WHERE w.nazwa_wycieczki = 'UNKNOWN';

-- Rezerwacja_F: Check for facts referencing UNKNOWN campaign
SELECT f.*
FROM Rezerwacja_F f
JOIN Nazwa_kampanii_D n ON f.id_nazwy_kampanii = n.id_nazwy_kampanii
WHERE n.nazwa_kampanii = 'UNKNOWN';

-- Rezerwacja_F: Check for facts referencing UNKNOWN junk
SELECT f.*
FROM Rezerwacja_F f
JOIN Junk_D j ON f.id_junk = j.id_junk
WHERE j.status_oplacenia = 'UNK';

-- Kampania_F: Check for facts referencing UNKNOWN date
SELECT f.*
FROM Kampania_F f
JOIN Data_D d ON f.id_daty = d.id_daty
WHERE d.rok = 'UNK' AND d.miesiac = 'UNK' AND d.dzien = 'UNK';

-- Kampania_F: Check for facts referencing UNKNOWN trip
SELECT f.*
FROM Kampania_F f
JOIN Wycieczka_D w ON f.id_wycieczki = w.id_wycieczki
WHERE w.nazwa_wycieczki = 'UNKNOWN';

SELECT * FROM Wycieczka_D WHERE id_wycieczki =  107

-- Kampania_F: Check for facts referencing UNKNOWN campaign
SELECT f.*
FROM Kampania_F f
JOIN Nazwa_kampanii_D n ON f.id_nazwy_kampanii = n.id_nazwy_kampanii
WHERE n.nazwa_kampanii = 'UNKNOWN';

SELECT * FROM Nazwa_kampanii_D WHERE id_nazwy_kampanii =  106

-- Kampania_F: Check for facts referencing UNKNOWN keyword
SELECT f.*
FROM Kampania_F f
JOIN Slowo_kluczowe_D s ON f.id_slowa_kluczowego = s.id_slowa_kluczowego
WHERE s.slowo_kluczowe = 'UNKNOWN';

SELECT * FROM Slowo_kluczowe_D WHERE id_slowa_kluczowego = 271
