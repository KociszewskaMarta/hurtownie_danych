USE sample_travel_agency_database
GO

WITH ClientReservations AS (
    SELECT 
        c.client_pesel,
        COUNT(rc.reservation_id) AS reservation_count
    FROM sample_travel_agency_database.dbo.Client c
    LEFT JOIN sample_travel_agency_database.dbo.ReservationClient rc ON c.client_pesel = rc.client_pesel
    GROUP BY c.client_pesel
),
SourceClients AS (
    SELECT 
        c.client_pesel,
        CASE 
            WHEN cr.reservation_count = 1 THEN 'Tak'
            ELSE 'Nie'
        END AS czy_nowy
    FROM sample_travel_agency_database.dbo.Client c
    LEFT JOIN ClientReservations cr ON c.client_pesel = cr.client_pesel
)
SELECT * FROM SourceClients;