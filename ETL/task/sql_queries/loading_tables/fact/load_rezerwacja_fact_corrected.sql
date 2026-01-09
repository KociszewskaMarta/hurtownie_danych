USE sample_warehouse;
GO

TRUNCATE TABLE dbo.Rezerwacja_F;
GO

-- Tworzenie tymczasowej tabeli dla danych CSV
IF OBJECT_ID('dbo.Marketing_Temp', 'U') IS NOT NULL
    DROP TABLE dbo.Marketing_Temp;
GO

CREATE TABLE Marketing_Temp (
    Date NVARCHAR(50),
    Campaing_Name NVARCHAR(255),
    Ad_group NVARCHAR(255),
    Trip_id NVARCHAR(50),
    Keyword NVARCHAR(255),
    Impressions NVARCHAR(50),
    Clicks NVARCHAR(50),
    CTR NVARCHAR(50),
    Cost NVARCHAR(50),
    Conversion_Rate NVARCHAR(50)
);
GO

-- Ładowanie danych z CSV
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
    ISNULL(wyc.id_wycieczki, (SELECT TOP 1 id_wycieczki FROM Wycieczka_D WHERE nazwa_wycieczki = 'UNKNOWN')),
    ISNULL(kamp.id_nazwy_kampanii, (SELECT TOP 1 id_nazwy_kampanii FROM Nazwa_kampanii_D WHERE nazwa_kampanii = 'UNKNOWN')),
    ISNULL(kl.id_klienta, (SELECT TOP 1 id_klienta FROM Klient_D WHERE pesel_klienta = 'UNKNOWN')),
    ISNULL(dat.id_daty, (SELECT TOP 1 id_daty FROM Data_D WHERE rok = 'UNK' AND miesiac = 'UNK' AND dzien = 'UNK')),
    ISNULL(junk.id_junk, (SELECT TOP 1 id_junk FROM Junk_D WHERE status_oplacenia = 'UNKNOWN')),
    ISNULL(p.amount, 0) AS kwota_transakcji,  -- Jeśli brak płatności, wartość 0
    te.price AS cena_turnusu
FROM sample_travel_agency_database_2.dbo.Reservation r
LEFT JOIN sample_travel_agency_database_2.dbo.ReservationClient rc 
    ON rc.reservation_id = r.reservation_id
LEFT JOIN sample_travel_agency_database_2.dbo.Client c 
    ON c.client_pesel = rc.client_pesel
LEFT JOIN Klient_D kl 
    ON kl.pesel_klienta = c.client_pesel
    AND kl.data_wygasniecia IS NULL
LEFT JOIN sample_travel_agency_database_2.dbo.TourEdition te 
    ON te.tour_edition_id = r.tour_edition_id
LEFT JOIN sample_travel_agency_database_2.dbo.Tour t 
    ON t.tour_id = te.tour_id
LEFT JOIN Wycieczka_D wyc 
    ON wyc.nazwa_wycieczki = t.name
LEFT JOIN sample_travel_agency_database_2.dbo.Payment p 
    ON p.reservation_id = r.reservation_id
LEFT JOIN (
    SELECT DISTINCT 
        CAST(Trip_id AS INT) AS Trip_id, 
        MIN(Campaing_Name) AS Campaing_Name
    FROM sample_warehouse.dbo.Marketing_Temp
    WHERE Trip_id IS NOT NULL AND Trip_id <> ''
    GROUP BY CAST(Trip_id AS INT)
) mt ON mt.Trip_id = t.tour_id
LEFT JOIN Nazwa_kampanii_D kamp 
    ON kamp.nazwa_kampanii = mt.Campaing_Name
LEFT JOIN Data_D dat 
    ON dat.rok = CAST(YEAR(r.reservation_date) AS NVARCHAR(4)) 
    AND dat.miesiac = CAST(MONTH(r.reservation_date) AS NVARCHAR(2))
    AND dat.dzien = CAST(DAY(r.reservation_date) AS NVARCHAR(10))
LEFT JOIN Junk_D junk 
    ON junk.status_oplacenia = CASE 
        WHEN r.reservation_status = 'Paid' THEN 'Tak'
        ELSE 'Nie'
    END
WHERE rc.reservation_id IS NOT NULL
GO

-- Sprawdzenie liczby załadowanych rekordów
SELECT COUNT(*) AS liczba_rekordow_w_Rezerwacja_F 
FROM Rezerwacja_F;
GO

-- Usunięcie tymczasowej tabeli Marketing_Temp
DROP TABLE dbo.Marketing_Temp;
GO

GO
