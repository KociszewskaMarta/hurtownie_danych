USE sample_travel_agency_database_2
GO

INSERT into reservation (reservation_date, reservation_status, tour_edition_id) VALUES ('2025-09-01', 'Unpaid', 1);
DECLARE @reservation_id INT = SCOPE_IDENTITY();
INSERT into reservationclient (reservation_id, client_pesel) VALUES (@reservation_id, '00040654321');
GO

USE sample_warehouse;
GO


SELECT * FROM Klient_D WHERE pesel_klienta = '00040654321' ORDER BY data_wpisania;
GO

SELECT 
    f.*,
    k.pesel_klienta,
    k.czy_nowy,
    w.nazwa_wycieczki,
    n.nazwa_kampanii,
    d.rok, d.miesiac, d.dzien,
    j.status_oplacenia
FROM Rezerwacja_F f
LEFT JOIN Klient_D k ON f.id_klienta = k.id_klienta
LEFT JOIN Wycieczka_D w ON f.id_wycieczki = w.id_wycieczki
LEFT JOIN Nazwa_kampanii_D n ON f.id_nazwy_kampanii = n.id_nazwy_kampanii
LEFT JOIN Data_D d ON f.id_daty = d.id_daty
LEFT JOIN Junk_D j ON f.id_junk = j.id_junk
WHERE k.pesel_klienta = '00040654321' AND k.data_wygasniecia IS NULL AND d.rok = '2025' AND d.miesiac = '9' AND d.dzien = '1';
