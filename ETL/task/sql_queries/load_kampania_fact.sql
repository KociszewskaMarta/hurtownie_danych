USE sample_warehouse;
GO
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
FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\ETL\task\sql_queries\facts_test\sample_marketing_data.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);
GO
-- Fix decimal separators and trim spaces
UPDATE Marketing_Temp
SET CTR = REPLACE(LTRIM(RTRIM(CTR)), ',', '.'),
    Cost = REPLACE(LTRIM(RTRIM(Cost)), ',', '.'),
    [Conversion Rate] = REPLACE(LTRIM(RTRIM([Conversion Rate])), ',', '.');
GO

-- Insert into fact table with dimension lookups
INSERT INTO dbo.Kampania_F (
    id_wycieczki,
    id_slowa_kluczowego,
    id_nazwy_kampanii,
    wspolczynnik_konwersji,
    koszt_kampanii,
    liczba_klikniec,
    koszt_na_klikniecie
)
SELECT
    wyc.id_wycieczki,
    slowo.id_slowa_kluczowego,
    kamp.id_nazwy_kampanii,
    TRY_CAST(m.[Conversion Rate] AS DECIMAL(5,2)),
    TRY_CAST(m.Cost AS INT),
    TRY_CAST(m.Clicks AS INT),
    CASE WHEN TRY_CAST(m.Clicks AS INT) > 0 THEN TRY_CAST(m.Cost AS INT) / TRY_CAST(m.Clicks AS INT) ELSE NULL END
FROM Marketing_Temp m
INNER JOIN Wycieczka_D wyc ON wyc.id_wycieczki = TRY_CAST(m.Trip_id AS INT)
INNER JOIN Slowo_kluczowe_D slowo ON slowo.slowo_kluczowe = m.Keyword
INNER JOIN Nazwa_kampanii_D kamp ON kamp.nazwa_kampanii = m.Campaing_Name
WHERE
    TRY_CAST(m.Trip_id AS INT) IS NOT NULL
    AND TRY_CAST(m.Clicks AS INT) IS NOT NULL
    AND TRY_CAST(m.Cost AS INT) IS NOT NULL
    AND m.Keyword IS NOT NULL
    AND m.Campaing_Name IS NOT NULL;
GO
DROP TABLE Marketing_Temp;
GO