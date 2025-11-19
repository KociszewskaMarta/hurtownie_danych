SELECT 
    w.nazwa_wycieczki,
    k.pesel_klienta,
    d.miesiac,
    r.kwota_transakcji
FROM Rezerwacja_F r
JOIN Wycieczka_D w ON r.id_wycieczki = w.id_wycieczki
JOIN Klient_D k ON r.id_klienta = k.id_klienta
JOIN Data_D d ON r.id_daty = d.id_daty;

SELECT 
    w.nazwa_wycieczki,
    d.pora_roku,
    s.slowo_kluczowe,
    n.nazwa_kampanii,
    k.koszt_kampanii,
    k.liczba_klikniec
FROM Kampania_F k
JOIN Wycieczka_D w ON k.id_wycieczki = w.id_wycieczki
JOIN Data_D d ON k.id_daty = d.id_daty
JOIN Slowo_kluczowe_D s ON k.id_slowa_kluczowego = s.id_slowa_kluczowego
JOIN Nazwa_kampanii_D n ON k.id_nazwy_kampanii = n.id_nazwy_kampanii;
