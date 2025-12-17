USE sample_warehouse
GO

INSERT INTO Rezerwacja_F (
    id_wycieczki,
    id_nazwy_kampanii,
    id_klienta,
    id_daty,
    id_junk,
    kwota_transakcji,
    cena_turnusu
)
SELECT DISTINCT
    wyc.id_wycieczki,
    kamp.id_nazwy_kampanii,
    kl.id_klienta,
    dat.id_daty,
    junk.id_junk,
    p.amount AS kwota_transakcji,
    te.price AS cena_turnusu
FROM sample_travel_agency_database.dbo.Reservation r
INNER JOIN sample_travel_agency_database.dbo.ReservationClient rc ON rc.reservation_id = r.reservation_id
INNER JOIN sample_travel_agency_database.dbo.Client c ON c.client_pesel = rc.client_pesel
INNER JOIN Klient_D kl ON kl.pesel_klienta = c.client_pesel
INNER JOIN sample_travel_agency_database.dbo.TourEdition te ON te.tour_edition_id = r.tour_edition_id
INNER JOIN sample_travel_agency_database.dbo.Tour t ON t.tour_id = te.tour_id
INNER JOIN Wycieczka_D wyc ON wyc.nazwa_wycieczki = t.name
LEFT JOIN sample_travel_agency_database.dbo.Payment p ON p.reservation_id = r.reservation_id
LEFT JOIN (
    SELECT DISTINCT Trip_id, MIN(Campaing_Name) AS Campaing_Name
    FROM Marketing_Temp
    GROUP BY Trip_id
) mt ON CAST(mt.Trip_id AS INT) = t.tour_id
LEFT JOIN Nazwa_kampanii_D kamp ON kamp.nazwa_kampanii = mt.Campaing_Name
INNER JOIN Data_D dat ON dat.rok = CAST(YEAR(r.reservation_date) AS NVARCHAR(4)) 
    AND dat.miesiac = CASE MONTH(r.reservation_date)
        WHEN 1 THEN 'Styczeń'
        WHEN 2 THEN 'Luty'
        WHEN 3 THEN 'Marzec'
        WHEN 4 THEN 'Kwiecień'
        WHEN 5 THEN 'Maj'
        WHEN 6 THEN 'Czerwiec'
        WHEN 7 THEN 'Lipiec'
        WHEN 8 THEN 'Sierpień'
        WHEN 9 THEN 'Wrzesień'
        WHEN 10 THEN 'Październik'
        WHEN 11 THEN 'Listopad'
        WHEN 12 THEN 'Grudzień'
    END
    AND dat.dzien = CAST(DAY(r.reservation_date) AS NVARCHAR(10))
INNER JOIN Junk_D junk ON junk.status_oplacenia = CASE WHEN p.payment_id IS NOT NULL THEN 'TAK' ELSE 'NIE' END
WHERE wyc.id_wycieczki IS NOT NULL 
    AND kl.id_klienta IS NOT NULL 
    AND dat.id_daty IS NOT NULL 
    AND junk.id_junk IS NOT NULL
    AND kamp.id_nazwy_kampanii IS NOT NULL;
GO