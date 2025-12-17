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