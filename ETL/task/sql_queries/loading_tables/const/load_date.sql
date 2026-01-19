USE warehouse_travel_agency
GO

DECLARE @StartDate date;
DECLARE @EndDate date;

SELECT @StartDate = '2015-1-1', @EndDate = '2025-12-31';

Declare @DateInProcess datetime = @StartDate;

While @DateInProcess <= @EndDate
    BEGIN
        Insert into [dbo].Data_D 
        ( [rok]
        , [pora_roku]
        , [miesiac]
        , [dzien]
        )
        Values ( 
              Cast( Year(@DateInProcess) as varchar(4)) -- [Year]
            , CASE 
                WHEN Month(@DateInProcess) IN (12, 1, 2) THEN 'Zima'
                WHEN Month(@DateInProcess) IN (3, 4, 5) THEN 'Wiosna'
                WHEN Month(@DateInProcess) IN (6, 7, 8) THEN 'Lato'
                WHEN Month(@DateInProcess) IN (9, 10, 11) THEN 'Jesień'
              END -- [Season]
            , Cast(Month(@DateInProcess) as varchar(2)) -- [Month]
            , Cast( Day(@DateInProcess) as int) -- [Day]
        );
        Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
    END
    GO

    IF NOT EXISTS (SELECT 1 FROM Data_D WHERE rok = 'UNK' AND miesiac = 'UNK' AND dzien = 'UNK')
    BEGIN
        INSERT INTO Data_D (rok, pora_roku, miesiac, dzien)
        VALUES ('UNK', 'UNK', 'UNK', 'UNK')
    END
    go
