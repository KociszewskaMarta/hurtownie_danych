USE sample_warehouse;
GO

-- TRUNCATE TABLE dbo.Kampania_F;
-- GO

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
FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\dataSourcesGenerator\python_scripts\generating_data\marketing_data.csv'
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
    ISNULL(wyc.id_wycieczki, (SELECT TOP 1 id_wycieczki FROM Wycieczka_D WHERE nazwa_wycieczki = 'UNKNOWN')),
    ISNULL(dat.id_daty, (SELECT TOP 1 id_daty FROM Data_D WHERE rok = 'UNKNOWN' AND miesiac = 'UNKNOWN' AND dzien = 'UNKNOWN')),
    ISNULL(slowo.id_slowa_kluczowego, (SELECT TOP 1 id_slowa_kluczowego FROM Slowo_kluczowe_D WHERE slowo_kluczowe = 'UNKNOWN')),
    ISNULL(kamp.id_nazwy_kampanii, (SELECT TOP 1 id_nazwy_kampanii FROM Nazwa_kampanii_D WHERE nazwa_kampanii = 'UNKNOWN')),
    TRY_CAST(mt.Conversion_Rate AS DECIMAL(5,2)) AS wspolczynnik_konwersji,
    TRY_CAST(mt.Cost AS DECIMAL(18,2)) AS koszt_kampanii,
    TRY_CAST(mt.Clicks AS INT) AS liczba_klikniec
FROM Marketing_Temp mt

-- Dopasowanie do wycieczki:
LEFT JOIN database_travel_agency.dbo.Tour t 
    ON t.tour_id = CAST(mt.Trip_id AS INT)
LEFT JOIN Wycieczka_D wyc 
    ON wyc.nazwa_wycieczki = t.name

-- Dopasowanie do daty:
LEFT JOIN Data_D dat 
    ON dat.rok = CAST(YEAR(CAST(mt.Date AS DATE)) AS NVARCHAR(4))
    AND dat.miesiac = CAST(MONTH(CAST(mt.Date AS DATE)) AS NVARCHAR(2))
    AND dat.dzien = CAST(DAY(CAST(mt.Date AS DATE)) AS NVARCHAR(10))

-- Dopasowanie do słowa kluczowego
LEFT JOIN Slowo_kluczowe_D slowo 
    ON slowo.slowo_kluczowe = mt.Keyword

-- Dopasowanie do nazwy kampanii
LEFT JOIN Nazwa_kampanii_D kamp 
    ON kamp.nazwa_kampanii = mt.Campaing_Name;
GO

SELECT COUNT(*) AS liczba_rekordow_w_Kampania_F 
FROM Kampania_F;
GO

-- Usunięcie tymczasowej tabeli Marketing_Temp
DROP TABLE dbo.Marketing_Temp;
GO
