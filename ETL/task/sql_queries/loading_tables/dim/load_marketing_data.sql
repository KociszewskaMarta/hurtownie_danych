USE warehouse_travel_agency
GO

-- tymczasowa tabela dla danych CSV
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

--  ładowanie danych z CSV
BULK INSERT Marketing_Temp
FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\dataSourcesGenerator\python_scripts\generating_data\marketing_data.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);
GO

-- zamiana przecinków na kropki
UPDATE Marketing_Temp
SET CTR = REPLACE(CTR, ',', '.'),
    Cost = REPLACE(Cost, ',', '.'),
    Conversion_Rate = REPLACE(Conversion_Rate, ',', '.');
GO

-- ładowanie unikalnych słów kluczowych z CSV
INSERT INTO Slowo_kluczowe_D (slowo_kluczowe)
SELECT DISTINCT m.Keyword
FROM Marketing_Temp m
WHERE m.Keyword IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM Slowo_kluczowe_D sk WHERE sk.slowo_kluczowe = m.Keyword
);
GO

-- Ensure UNKNOWN row exists in Slowo_kluczowe_D
IF NOT EXISTS (SELECT 1 FROM Slowo_kluczowe_D WHERE slowo_kluczowe = 'UNKNOWN')
BEGIN
    INSERT INTO Slowo_kluczowe_D (slowo_kluczowe) VALUES ('UNKNOWN')
END
GO

-- ładowanie unikalnych nazw kampanii z CSV
INSERT INTO Nazwa_kampanii_D (nazwa_kampanii)
SELECT DISTINCT m.Campaing_Name
FROM Marketing_Temp m
WHERE m.Campaing_Name IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM Nazwa_kampanii_D nk WHERE nk.nazwa_kampanii = m.Campaing_Name
);
GO

-- Ensure UNKNOWN row exists in Nazwa_kampanii_D
IF NOT EXISTS (SELECT 1 FROM Nazwa_kampanii_D WHERE nazwa_kampanii = 'UNKNOWN')
BEGIN
    INSERT INTO Nazwa_kampanii_D (nazwa_kampanii) VALUES ('UNKNOWN')
END
GO

-- usunięcie tymczasowej tabeli
DROP TABLE dbo.Marketing_Temp;
GO
