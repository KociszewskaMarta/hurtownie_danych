
USE sample_warehouse;
GO

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

BULK INSERT Marketing_Temp
FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\ETL\task\sql_queries\sample_sources\sample_marketing_data.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);
GO

SELECT 
    COUNT(DISTINCT r.reservation_id) AS liczba_rezerwacji_zrodlo
FROM sample_travel_agency_database.dbo.Reservation r
INNER JOIN sample_travel_agency_database.dbo.TourEdition te ON te.tour_edition_id = r.tour_edition_id
INNER JOIN sample_travel_agency_database.dbo.Tour t ON t.tour_id = te.tour_id
WHERE EXISTS (
    SELECT 1 FROM sample_warehouse.dbo.Marketing_Temp mt 
    WHERE CAST(mt.Trip_id AS INT) = t.tour_id
);
SELECT COUNT(*) AS liczba_rekordow_hurtownia
FROM Rezerwacja_F;

SELECT 
    SUM(ISNULL(p.amount, 0)) AS suma_kwot_zrodlo
FROM sample_travel_agency_database.dbo.Reservation r
LEFT JOIN sample_travel_agency_database.dbo.Payment p ON p.reservation_id = r.reservation_id
INNER JOIN sample_travel_agency_database.dbo.TourEdition te ON te.tour_edition_id = r.tour_edition_id
INNER JOIN sample_travel_agency_database.dbo.Tour t ON t.tour_id = te.tour_id
WHERE EXISTS (
    SELECT 1 FROM sample_warehouse.dbo.Marketing_Temp mt 
    WHERE CAST(mt.Trip_id AS INT) = t.tour_id
);
SELECT 
    SUM(kwota_transakcji) AS suma_kwot_hurtownia
FROM Rezerwacja_F;

IF OBJECT_ID('dbo.ZrodloTemp_Export') IS NOT NULL DROP TABLE dbo.ZrodloTemp_Export;
SELECT 
    r.reservation_id,
    t.name AS nazwa_wycieczki,
    c.client_pesel,
    CONVERT(VARCHAR(10), r.reservation_date, 120) AS reservation_date,
    CASE WHEN r.reservation_status = 'Paid' THEN 'Tak' ELSE 'Nie' END AS status_oplacenia,
    ISNULL(p.amount, 0) AS kwota_transakcji,
    te.price AS cena_turnusu,
    mt.Campaing_Name AS nazwa_kampanii
INTO dbo.ZrodloTemp_Export
FROM sample_travel_agency_database.dbo.Reservation r
INNER JOIN sample_travel_agency_database.dbo.ReservationClient rc ON rc.reservation_id = r.reservation_id
INNER JOIN sample_travel_agency_database.dbo.Client c ON c.client_pesel = rc.client_pesel
INNER JOIN sample_travel_agency_database.dbo.TourEdition te ON te.tour_edition_id = r.tour_edition_id
INNER JOIN sample_travel_agency_database.dbo.Tour t ON t.tour_id = te.tour_id
LEFT JOIN sample_travel_agency_database.dbo.Payment p ON p.reservation_id = r.reservation_id
LEFT JOIN (
    SELECT DISTINCT CAST(Trip_id AS INT) AS Trip_id, MIN(Campaing_Name) AS Campaing_Name
    FROM sample_warehouse.dbo.Marketing_Temp
    WHERE Trip_id IS NOT NULL AND Trip_id <> ''
    GROUP BY CAST(Trip_id AS INT)
) mt ON mt.Trip_id = t.tour_id
WHERE mt.Campaing_Name IS NOT NULL
ORDER BY r.reservation_id;
IF OBJECT_ID('dbo.HurtowniaTemp_Export') IS NOT NULL DROP TABLE dbo.HurtowniaTemp_Export;
SELECT 
    w.nazwa_wycieczki,
    kl.pesel_klienta,
    d.rok + '-' + RIGHT('0' + d.miesiac, 2) + '-' + RIGHT('0' + d.dzien, 2) AS reservation_date,
    j.status_oplacenia,
    r.kwota_transakcji,
    r.cena_turnusu,
    k.nazwa_kampanii
INTO dbo.HurtowniaTemp_Export
FROM Rezerwacja_F r
INNER JOIN Wycieczka_D w ON w.id_wycieczki = r.id_wycieczki
INNER JOIN Klient_D kl ON kl.id_klienta = r.id_klienta
INNER JOIN Data_D d ON d.id_daty = r.id_daty
INNER JOIN Junk_D j ON j.id_junk = r.id_junk
INNER JOIN Nazwa_kampanii_D k ON k.id_nazwy_kampanii = r.id_nazwy_kampanii
ORDER BY w.nazwa_wycieczki, kl.pesel_klienta, reservation_date;
SELECT * FROM dbo.ZrodloTemp_Export;
SELECT * FROM dbo.HurtowniaTemp_Export;
DROP TABLE dbo.ZrodloTemp_Export;
DROP TABLE dbo.HurtowniaTemp_Export;

SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK - Wszystkie wycieczki istnieją w wymiarze'
        ELSE 'BŁĄD - ' + CAST(COUNT(*) AS VARCHAR) + ' rekordów bez wycieczki'
    END AS status_wycieczki
FROM Rezerwacja_F r
LEFT JOIN Wycieczka_D w ON w.id_wycieczki = r.id_wycieczki
WHERE w.id_wycieczki IS NULL;
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK - Wszyscy klienci istnieją w wymiarze'
        ELSE 'BŁĄD - ' + CAST(COUNT(*) AS VARCHAR) + ' rekordów bez klienta'
    END AS status_klienta
FROM Rezerwacja_F r
LEFT JOIN Klient_D kl ON kl.id_klienta = r.id_klienta
WHERE kl.id_klienta IS NULL;
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK - Wszystkie daty istnieją w wymiarze'
        ELSE 'BŁĄD - ' + CAST(COUNT(*) AS VARCHAR) + ' rekordów bez daty'
    END AS status_daty
FROM Rezerwacja_F r
LEFT JOIN Data_D d ON d.id_daty = r.id_daty
WHERE d.id_daty IS NULL;
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK - Wszystkie kampanie istnieją w wymiarze'
        ELSE 'BŁĄD - ' + CAST(COUNT(*) AS VARCHAR) + ' rekordów bez kampanii'
    END AS status_kampanii
FROM Rezerwacja_F r
LEFT JOIN Nazwa_kampanii_D k ON k.id_nazwy_kampanii = r.id_nazwy_kampanii
WHERE k.id_nazwy_kampanii IS NULL;

SELECT 
    'Rezerwacja_F' AS tabela,
    COUNT(*) AS liczba_rekordow,
    SUM(kwota_transakcji) AS suma_kwot,
    AVG(kwota_transakcji) AS srednia_kwota,
    MIN(kwota_transakcji) AS min_kwota,
    MAX(kwota_transakcji) AS max_kwota,
    SUM(cena_turnusu) AS suma_cen_turnusow,
    AVG(cena_turnusu) AS srednia_cena_turnusu
FROM Rezerwacja_F;

SELECT 
    'ŹRÓDŁO' AS zrodlo,
    CASE WHEN r.reservation_status = 'Paid' THEN 'Tak' ELSE 'Nie' END AS status_oplacenia,
    COUNT(*) AS liczba
FROM sample_travel_agency_database.dbo.Reservation r
INNER JOIN sample_travel_agency_database.dbo.TourEdition te ON te.tour_edition_id = r.tour_edition_id
INNER JOIN sample_travel_agency_database.dbo.Tour t ON t.tour_id = te.tour_id
WHERE EXISTS (
    SELECT 1 FROM sample_warehouse.dbo.Marketing_Temp mt 
    WHERE CAST(mt.Trip_id AS INT) = t.tour_id
)
GROUP BY CASE WHEN r.reservation_status = 'Paid' THEN 'Tak' ELSE 'Nie' END;
SELECT 
    'HURTOWNIA' AS zrodlo,
    j.status_oplacenia,
    COUNT(*) AS liczba
FROM Rezerwacja_F r
INNER JOIN Junk_D j ON j.id_junk = r.id_junk
GROUP BY j.status_oplacenia;
DROP TABLE dbo.Marketing_Temp;
GO
