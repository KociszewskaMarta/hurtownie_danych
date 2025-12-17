USE sample_warehouse
GO

-- INSERT INTO Rezerwacja_F (
--    id_wycieczki,
--    id_nazwy_kampanii,
--    id_klienta,
--    id_daty,
--    id_junk,
--    kwota_transakcji,
--    cena_turnusu
--)
SELECT
    r.reservation_id,
    t.name AS tour_name,
    wyc.id_wycieczki,
    c.client_pesel,
    kl.id_klienta,
    r.reservation_date,
    dat.id_daty,
    te.price,
    p.amount,
    CASE WHEN p.payment_id IS NOT NULL THEN 'TAK' ELSE 'NIE' END AS status_oplacenia,
    junk.id_junk
FROM sample_travel_agency_database.dbo.Reservation r
INNER JOIN sample_travel_agency_database.dbo.ReservationClient rc ON rc.reservation_id = r.reservation_id
INNER JOIN sample_travel_agency_database.dbo.Client c ON c.client_pesel = rc.client_pesel
LEFT JOIN Klient_D kl ON kl.pesel_klienta = c.client_pesel
INNER JOIN sample_travel_agency_database.dbo.TourEdition te ON te.tour_edition_id = r.tour_edition_id
INNER JOIN sample_travel_agency_database.dbo.Tour t ON t.tour_id = te.tour_id
LEFT JOIN Wycieczka_D wyc ON wyc.nazwa_wycieczki = t.name
LEFT JOIN sample_travel_agency_database.dbo.Payment p ON p.reservation_id = r.reservation_id
LEFT JOIN Data_D dat ON dat.rok = CAST(YEAR(r.reservation_date) AS NVARCHAR(4)) AND dat.miesiac = CAST(MONTH(r.reservation_date) AS NVARCHAR(10)) AND dat.dzien = CAST(DAY(r.reservation_date) AS NVARCHAR(10))
LEFT JOIN Junk_D junk ON junk.status_oplacenia = CASE WHEN p.payment_id IS NOT NULL THEN 'TAK' ELSE 'NIE' END
GO