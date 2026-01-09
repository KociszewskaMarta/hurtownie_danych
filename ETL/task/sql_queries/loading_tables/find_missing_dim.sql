-- Finds missing foreign key references for fact table loading

IF OBJECT_ID('dbo.Marketing_Temp') IS NOT NULL DROP TABLE dbo.Marketing_Temp;
GO
CREATE TABLE Marketing_Temp (
    [Date] NVARCHAR(50),
    Campaing_Name NVARCHAR(255),
    [Ad-group] NVARCHAR(255),
    Trip_id NVARCHAR(50),
    Keyword NVARCHAR(255),
    Impressions NVARCHAR(50),
    Clicks NVARCHAR(50),
    CTR NVARCHAR(50),
    Cost NVARCHAR(50),
    [Conversion Rate] NVARCHAR(50)
);
GO
BULK INSERT Marketing_Temp
FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\ETL\task\sql_queries\sample_sources\sample_marketing_data_ready.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);
GO

SELECT
  r.reservation_id,
  CASE WHEN wyc.id_wycieczki IS NULL THEN 'Wycieczka_D' END AS missing_wycieczka,
  CASE WHEN kl.id_klienta IS NULL THEN 'Klient_D' END AS missing_klient,
  CASE WHEN dat.id_daty IS NULL THEN 'Data_D' END AS missing_data,
  CASE WHEN junk.id_junk IS NULL THEN 'Junk_D' END AS missing_junk,
  CASE WHEN kamp.id_nazwy_kampanii IS NULL THEN 'Kampania' END AS missing_kampania
FROM sample_travel_agency_database_2.dbo.Reservation r
LEFT JOIN sample_travel_agency_database_2.dbo.ReservationClient rc ON rc.reservation_id = r.reservation_id
LEFT JOIN sample_travel_agency_database_2.dbo.Client c ON c.client_pesel = rc.client_pesel
LEFT JOIN Klient_D kl ON kl.pesel_klienta = c.client_pesel AND kl.data_wygasniecia IS NULL
LEFT JOIN sample_travel_agency_database_2.dbo.TourEdition te ON te.tour_edition_id = r.tour_edition_id
LEFT JOIN sample_travel_agency_database_2.dbo.Tour t ON t.tour_id = te.tour_id
LEFT JOIN Wycieczka_D wyc ON wyc.nazwa_wycieczki = t.name
LEFT JOIN Data_D dat ON dat.rok = CAST(YEAR(r.reservation_date) AS NVARCHAR(4)) 
    AND dat.miesiac = CAST(MONTH(r.reservation_date) AS NVARCHAR(2))
    AND dat.dzien = CAST(DAY(r.reservation_date) AS NVARCHAR(10))
LEFT JOIN Junk_D junk ON junk.status_oplacenia = CASE WHEN r.reservation_status = 'Paid' THEN 'Tak' ELSE 'Nie' END
LEFT JOIN (
    SELECT DISTINCT 
        CAST(Trip_id AS INT) AS Trip_id, 
        MIN(Campaing_Name) AS Campaing_Name
    FROM sample_warehouse.dbo.Marketing_Temp
    WHERE Trip_id IS NOT NULL AND Trip_id <> ''
    GROUP BY CAST(Trip_id AS INT)
) mt ON mt.Trip_id = t.tour_id
LEFT JOIN Nazwa_kampanii_D kamp ON kamp.nazwa_kampanii = mt.Campaing_Name
WHERE
  wyc.id_wycieczki IS NULL
  OR kl.id_klienta IS NULL
  OR dat.id_daty IS NULL
  OR junk.id_junk IS NULL
  OR kamp.id_nazwy_kampanii IS NULL;

DROP TABLE dbo.Marketing_Temp;
GO