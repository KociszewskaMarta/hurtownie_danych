USE HD_warehouse_real_data;
GO

-- Step 1: Prepare source data with 'czy_nowy' calculation
WITH ClientReservations AS (
    SELECT 
        c.client_pesel,
        COUNT(rc.reservation_id) AS reservation_count
    FROM go_explore_travel_agency.dbo.Client c
    LEFT JOIN go_explore_travel_agency.dbo.ReservationClient rc ON c.client_pesel = rc.client_pesel
    GROUP BY c.client_pesel
),
SourceClients AS (
    SELECT 
        c.client_pesel,
        CASE 
            WHEN cr.reservation_count = 1 THEN 'Tak'
            ELSE 'Nie'
        END AS czy_nowy
    FROM go_explore_travel_agency.dbo.Client c
    LEFT JOIN ClientReservations cr ON c.client_pesel = cr.client_pesel
)

-- Step 2: Expire old records in Klient_D if 'czy_nowy' changed
UPDATE dwh
SET dwh.data_wygasniecia = GETDATE() -- set expiration date to now
FROM HD_warehouse_real_data.dbo.Klient_D dwh 
JOIN SourceClients sc ON dwh.pesel_klienta = sc.client_pesel 
WHERE dwh.czy_nowy <> sc.czy_nowy AND dwh.data_wygasniecia IS NULL;
-- 'Tak' != 'Nie', in datawarehouse client is set to new 
-- but after matching the client from source it is not new anymore as client made more than 1 reservation

-- Step 3: Insert new records for new or changed clients
INSERT INTO HD_warehouse_real_data.dbo.Klient_D (pesel_klienta, czy_nowy, data_wpisania, data_wygasniecia)
SELECT 
    sc.client_pesel,
    sc.czy_nowy,
    GETDATE(), -- for new records, set entry date to now
    NULL -- for new records, expiration date is null
FROM SourceClients sc
LEFT JOIN HD_warehouse_real_data.dbo.Klient_D dwh
    ON sc.client_pesel = dwh.pesel_klienta 
    AND dwh.data_wygasniecia IS NULL
WHERE dwh.pesel_klienta IS NULL -- new client
    OR dwh.czy_nowy <> sc.czy_nowy; -- changed 'czy_nowy'

-- first load - step 2 is skipped as there are no existing records
-- subsequent loads - step 2 will expire records with changed 'czy_nowy' and step 3 will insert new records

