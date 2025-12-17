-- =============================================================================
-- Skrypt weryfikacyjny: Kampania_F vs plik marketingowy
-- =============================================================================

USE sample_warehouse;
GO

-- Tworzenie tymczasowej tabeli dla danych CSV (do weryfikacji)
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

PRINT '========================================';
PRINT '1. PORÓWNANIE LICZBY REKORDÓW';
PRINT '========================================';

-- Liczba rekordów w pliku marketingowym
SELECT COUNT(*) AS liczba_rekordow_plik
FROM Marketing_Temp;

-- Liczba rekordów w hurtowni
SELECT COUNT(*) AS liczba_rekordow_hurtownia
FROM Kampania_F;

PRINT '';
PRINT '========================================';
PRINT '2. PORÓWNANIE SUM I ŚREDNICH';
PRINT '========================================';

-- Suma i średnia kosztów kampanii z pliku
SELECT 
    SUM(TRY_CAST(Cost AS DECIMAL(18,2))) AS suma_koszt_plik,
    AVG(TRY_CAST(Cost AS DECIMAL(18,2))) AS srednia_koszt_plik,
    SUM(TRY_CAST(Clicks AS INT)) AS suma_klikniec_plik,
    AVG(TRY_CAST(Clicks AS INT)) AS srednia_klikniec_plik,
    SUM(TRY_CAST(Conversion_Rate AS DECIMAL(5,2))) AS suma_konwersji_plik,
    AVG(TRY_CAST(Conversion_Rate AS DECIMAL(5,2))) AS srednia_konwersji_plik
FROM Marketing_Temp;

-- Suma i średnia kosztów kampanii w hurtowni
SELECT 
    SUM(koszt_kampanii) AS suma_koszt_hurtownia,
    AVG(koszt_kampanii) AS srednia_koszt_hurtownia,
    SUM(liczba_klikniec) AS suma_klikniec_hurtownia,
    AVG(liczba_klikniec) AS srednia_klikniec_hurtownia,
    SUM(wspolczynnik_konwersji) AS suma_konwersji_hurtownia,
    AVG(wspolczynnik_konwersji) AS srednia_konwersji_hurtownia
FROM Kampania_F;

PRINT '';
PRINT '========================================';
PRINT '3. PORÓWNANIE SZCZEGÓŁOWE - EKSPORT DO CSV';
PRINT '========================================';

-- Tworzenie tymczasowej tabeli dla danych z pliku (tabela rzeczywista, nie #temp)
IF OBJECT_ID('dbo.MarketingTemp_Export') IS NOT NULL DROP TABLE dbo.MarketingTemp_Export;
SELECT 
    Date,
    Campaing_Name,
    Keyword,
    TRY_CAST(Cost AS DECIMAL(18,2)) AS Cost,
    TRY_CAST(Clicks AS INT) AS Clicks,
    TRY_CAST(Conversion_Rate AS DECIMAL(5,2)) AS Conversion_Rate
INTO dbo.MarketingTemp_Export
FROM Marketing_Temp;

-- Tworzenie tymczasowej tabeli dla danych z hurtowni (tabela rzeczywista, nie #temp)
IF OBJECT_ID('dbo.KampaniaF_Export') IS NOT NULL DROP TABLE dbo.KampaniaF_Export;
SELECT 
    d.rok + '-' + RIGHT('0' + d.miesiac, 2) + '-' + RIGHT('0' + d.dzien, 2) AS Date,
    k.nazwa_kampanii AS Campaing_Name,
    s.slowo_kluczowe AS Keyword,
    f.koszt_kampanii AS Cost,
    f.liczba_klikniec AS Clicks,
    f.wspolczynnik_konwersji AS Conversion_Rate
INTO dbo.KampaniaF_Export
FROM Kampania_F f
INNER JOIN Wycieczka_D w ON w.id_wycieczki = f.id_wycieczki
INNER JOIN Data_D d ON d.id_daty = f.id_daty
INNER JOIN Slowo_kluczowe_D s ON s.id_slowa_kluczowego = f.id_slowa_kluczowego
INNER JOIN Nazwa_kampanii_D k ON k.id_nazwy_kampanii = f.id_nazwy_kampanii;

-- Wyświetlenie danych
SELECT * FROM dbo.MarketingTemp_Export;
SELECT * FROM dbo.KampaniaF_Export;

-- Usunięcie tabel tymczasowych
DROP TABLE dbo.MarketingTemp_Export;
DROP TABLE dbo.KampaniaF_Export;

PRINT '';
PRINT '========================================';
PRINT '4. SPRAWDZENIE INTEGRALNOŚCI WYMIARÓW';
PRINT '========================================';

-- Czy wszystkie wycieczki z faktów istnieją w wymiarze
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK - Wszystkie wycieczki istnieją w wymiarze'
        ELSE 'BŁĄD - ' + CAST(COUNT(*) AS VARCHAR) + ' rekordów bez wycieczki'
    END AS status_wycieczki
FROM Kampania_F f
LEFT JOIN Wycieczka_D w ON w.id_wycieczki = f.id_wycieczki
WHERE w.id_wycieczki IS NULL;

-- Czy wszystkie daty z faktów istnieją w wymiarze
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK - Wszystkie daty istnieją w wymiarze'
        ELSE 'BŁĄD - ' + CAST(COUNT(*) AS VARCHAR) + ' rekordów bez daty'
    END AS status_daty
FROM Kampania_F f
LEFT JOIN Data_D d ON d.id_daty = f.id_daty
WHERE d.id_daty IS NULL;

-- Czy wszystkie słowa kluczowe z faktów istnieją w wymiarze
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK - Wszystkie słowa kluczowe istnieją w wymiarze'
        ELSE 'BŁĄD - ' + CAST(COUNT(*) AS VARCHAR) + ' rekordów bez słowa kluczowego'
    END AS status_slowa
FROM Kampania_F f
LEFT JOIN Slowo_kluczowe_D s ON s.id_slowa_kluczowego = f.id_slowa_kluczowego
WHERE s.id_slowa_kluczowego IS NULL;

-- Czy wszystkie kampanie z faktów istnieją w wymiarze
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK - Wszystkie kampanie istnieją w wymiarze'
        ELSE 'BŁĄD - ' + CAST(COUNT(*) AS VARCHAR) + ' rekordów bez kampanii'
    END AS status_kampanii
FROM Kampania_F f
LEFT JOIN Nazwa_kampanii_D k ON k.id_nazwy_kampanii = f.id_nazwy_kampanii
WHERE k.id_nazwy_kampanii IS NULL;

PRINT '';
PRINT '========================================';
PRINT '5. STATYSTYKI OPISOWE';
PRINT '========================================';

-- Statystyki z hurtowni
SELECT 
    'Kampania_F' AS tabela,
    COUNT(*) AS liczba_rekordow,
    SUM(koszt_kampanii) AS suma_koszt,
    AVG(koszt_kampanii) AS srednia_koszt,
    SUM(liczba_klikniec) AS suma_klikniec,
    AVG(liczba_klikniec) AS srednia_klikniec,
    SUM(wspolczynnik_konwersji) AS suma_konwersji,
    AVG(wspolczynnik_konwersji) AS srednia_konwersji
FROM Kampania_F;

PRINT '';
PRINT 'Weryfikacja zakończona!';

-- Usunięcie tymczasowej tabeli Marketing_Temp
DROP TABLE dbo.Marketing_Temp;
GO
