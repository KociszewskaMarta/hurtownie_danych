USE sample_warehouse;
GO

TRUNCATE TABLE dbo.Kampania_F;
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
    TABLOCK,
    CODEPAGE = '65001'
);
GO

-- Czyszczenie tabeli faktów (opcjonalnie)
-- TRUNCATE TABLE Kampania_F;
-- GO

INSERT INTO Kampania_F (
    id_wycieczki,
    id_daty,
    id_slowa_kluczowego,
    id_nazwy_kampanii,
    wspolczynnik_konwersji,
    koszt_kampanii,
    liczba_klikniec
)
SELECT DISTINCT
    wyc.id_wycieczki,
    dat.id_daty,
    slowo.id_slowa_kluczowego,
    kamp.id_nazwy_kampanii,
    -- Prosta konwersja, bo dane są już poprawnie sformatowane
    TRY_CAST(mt.Conversion_Rate AS DECIMAL(5,2)) AS wspolczynnik_konwersji,
    TRY_CAST(mt.Cost AS DECIMAL(18,2)) AS koszt_kampanii,
    TRY_CAST(mt.Clicks AS INT) AS liczba_klikniec
FROM Marketing_Temp mt

-- Dopasowanie do wycieczki:
-- Trip_id z CSV -> Tour.tour_id -> Tour.name -> Wycieczka_D.nazwa_wycieczki
INNER JOIN sample_travel_agency_database_2.dbo.Tour t 
    ON t.tour_id = CAST(mt.Trip_id AS INT)

INNER JOIN Wycieczka_D wyc 
    ON wyc.nazwa_wycieczki = t.name

-- Dopasowanie do daty:
-- Parsowanie daty z CSV (format: YYYY-MM-DD) i dopasowanie do Data_D
INNER JOIN Data_D dat 
    ON dat.rok = CAST(YEAR(CAST(mt.Date AS DATE)) AS NVARCHAR(4))
    AND dat.miesiac = CAST(MONTH(CAST(mt.Date AS DATE)) AS NVARCHAR(2))
    AND dat.dzien = CAST(DAY(CAST(mt.Date AS DATE)) AS NVARCHAR(10))

-- Dopasowanie do słowa kluczowego
INNER JOIN Slowo_kluczowe_D slowo 
    ON slowo.slowo_kluczowe = mt.Keyword

-- Dopasowanie do nazwy kampanii
INNER JOIN Nazwa_kampanii_D kamp 
    ON kamp.nazwa_kampanii = mt.Campaing_Name

-- Warunki filtrujące - wszystkie wymiary muszą istnieć
WHERE mt.Trip_id IS NOT NULL 
    AND mt.Trip_id <> ''
    AND mt.Date IS NOT NULL 
    AND mt.Date <> ''
    AND mt.Keyword IS NOT NULL 
    AND mt.Keyword <> ''
    AND mt.Campaing_Name IS NOT NULL 
    AND mt.Campaing_Name <> ''
    AND wyc.id_wycieczki IS NOT NULL 
    AND dat.id_daty IS NOT NULL 
    AND slowo.id_slowa_kluczowego IS NOT NULL 
    AND kamp.id_nazwy_kampanii IS NOT NULL;
GO

-- Usunięcie tymczasowej tabeli Marketing_Temp
DROP TABLE dbo.Marketing_Temp;
GO
