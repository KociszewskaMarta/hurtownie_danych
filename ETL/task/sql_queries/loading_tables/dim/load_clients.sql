USE warehouse_travel_agency;
GO

WITH ClientReservations AS (
    SELECT 
        c.client_pesel,
        COUNT(rc.reservation_id) AS reservation_count
    FROM database_travel_agency.dbo.Client c
    LEFT JOIN database_travel_agency.dbo.ReservationClient rc ON c.client_pesel = rc.client_pesel
    GROUP BY c.client_pesel
),
SourceClients AS (
    SELECT 
        c.client_pesel,
        CASE 
            WHEN cr.reservation_count = 1 THEN 'Tak'
            ELSE 'Nie'
        END AS czy_nowy
    FROM database_travel_agency.dbo.Client c
    LEFT JOIN ClientReservations cr ON c.client_pesel = cr.client_pesel
    WHERE c.client_pesel <> '00000000000'
)
UPDATE dwh
SET dwh.data_wygasniecia = GETDATE() -- set expiration date to now
FROM sample_warehouse.dbo.Klient_D dwh 
JOIN SourceClients sc ON dwh.pesel_klienta = sc.client_pesel 
WHERE dwh.czy_nowy <> sc.czy_nowy AND dwh.data_wygasniecia IS NULL;

WITH ClientReservations AS (
    SELECT 
        c.client_pesel,
        COUNT(rc.reservation_id) AS reservation_count
    FROM database_travel_agency.dbo.Client c
    LEFT JOIN database_travel_agency.dbo.ReservationClient rc ON c.client_pesel = rc.client_pesel
    GROUP BY c.client_pesel
),
SourceClients AS (
    SELECT 
        c.client_pesel,
        CASE 
            WHEN cr.reservation_count = 1 THEN 'Tak'
            ELSE 'Nie'
        END AS czy_nowy
    FROM database_travel_agency.dbo.Client c
    LEFT JOIN ClientReservations cr ON c.client_pesel = cr.client_pesel
    WHERE c.client_pesel <> '00000000000'
)
INSERT INTO sample_warehouse.dbo.Klient_D (pesel_klienta, czy_nowy, data_wpisania, data_wygasniecia)
SELECT 
    sc.client_pesel,
    sc.czy_nowy,
    GETDATE(), -- for new records, set entry date to now
    NULL -- for new records, expiration date is null
FROM SourceClients sc
LEFT JOIN sample_warehouse.dbo.Klient_D dwh
    ON sc.client_pesel = dwh.pesel_klienta 
    AND dwh.data_wygasniecia IS NULL
WHERE dwh.pesel_klienta IS NULL -- new client
    OR dwh.czy_nowy <> sc.czy_nowy; -- changed 'czy_nowy'


IF NOT EXISTS (SELECT 1 FROM Klient_D WHERE pesel_klienta = 'UNKNOWN')
BEGIN
    INSERT INTO Klient_D (pesel_klienta, czy_nowy, data_wpisania, data_wygasniecia)
    VALUES ('UNKNOWN', 'NIE', NULL, NULL)
END

