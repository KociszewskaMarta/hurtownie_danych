USE sample_warehouse;
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

-- Czyszczenie tabeli faktów (opcjonalnie)
-- TRUNCATE TABLE Rezerwacja_F;
-- GO

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
    ISNULL(p.amount, 0) AS kwota_transakcji,  -- Jeśli brak płatności, wartość 0
    te.price AS cena_turnusu
FROM sample_travel_agency_database.dbo.Reservation r

-- Połączenie z klientem przez tabelę ReservationClient
INNER JOIN sample_travel_agency_database.dbo.ReservationClient rc 
    ON rc.reservation_id = r.reservation_id
INNER JOIN sample_travel_agency_database.dbo.Client c 
    ON c.client_pesel = rc.client_pesel

-- Dopasowanie do wymiaru Klient_D po PESEL
INNER JOIN Klient_D kl 
    ON kl.pesel_klienta = c.client_pesel
    AND kl.data_wygasniecia IS NULL  -- aktywny rekord (SCD Type 2)

-- Połączenie z turnusem i wycieczką
INNER JOIN sample_travel_agency_database.dbo.TourEdition te 
    ON te.tour_edition_id = r.tour_edition_id
INNER JOIN sample_travel_agency_database.dbo.Tour t 
    ON t.tour_id = te.tour_id

-- Dopasowanie do wymiaru Wycieczka_D po nazwie wycieczki
INNER JOIN Wycieczka_D wyc 
    ON wyc.nazwa_wycieczki = t.name

-- Płatność (LEFT JOIN bo może nie być jeszcze płatności)
LEFT JOIN sample_travel_agency_database.dbo.Payment p 
    ON p.reservation_id = r.reservation_id

-- Dopasowanie nazwy kampanii z CSV przez Trip_id
-- Bierzemy pierwszą kampanię dla danego Trip_id jeśli jest wiele
LEFT JOIN (
    SELECT DISTINCT 
        CAST(Trip_id AS INT) AS Trip_id, 
        MIN(Campaing_Name) AS Campaing_Name
    FROM sample_warehouse.dbo.Marketing_Temp
    WHERE Trip_id IS NOT NULL AND Trip_id <> ''
    GROUP BY CAST(Trip_id AS INT)
) mt ON mt.Trip_id = t.tour_id

-- Dopasowanie do wymiaru Nazwa_kampanii_D
LEFT JOIN Nazwa_kampanii_D kamp 
    ON kamp.nazwa_kampanii = mt.Campaing_Name

-- Dopasowanie do wymiaru Data_D po roku, miesiącu i dniu
INNER JOIN Data_D dat 
    ON dat.rok = CAST(YEAR(r.reservation_date) AS NVARCHAR(4)) 
    AND dat.miesiac = CAST(MONTH(r.reservation_date) AS NVARCHAR(2))
    AND dat.dzien = CAST(DAY(r.reservation_date) AS NVARCHAR(10))

-- Dopasowanie do wymiaru Junk_D (status opłacenia)
-- 'Paid' -> 'Tak', 'Unpaid'/'Processing' -> 'Nie'
INNER JOIN Junk_D junk 
    ON junk.status_oplacenia = CASE 
        WHEN r.reservation_status = 'Paid' THEN 'Tak'
        ELSE 'Nie'
    END

-- Warunki filtrujące - wszystkie wymiary muszą istnieć
WHERE wyc.id_wycieczki IS NOT NULL 
    AND kl.id_klienta IS NOT NULL 
    AND dat.id_daty IS NOT NULL 
    AND junk.id_junk IS NOT NULL
    AND kamp.id_nazwy_kampanii IS NOT NULL;  -- Tylko rezerwacje z kampanią
GO

-- Sprawdzenie liczby załadowanych rekordów
SELECT COUNT(*) AS liczba_rekordow_w_Rezerwacja_F 
FROM Rezerwacja_F;
GO

-- Usunięcie tymczasowej tabeli Marketing_Temp
DROP TABLE dbo.Marketing_Temp;
GO

GO
