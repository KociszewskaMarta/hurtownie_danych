USE HD_warhouse
GO

DECLARE @StartDate date;
DECLARE @EndDate date;

SELECT @StartDate = '2015-1-1', @EndDate = '2025-7-1';

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
            , CASE Month(@DateInProcess)
                WHEN 1 THEN 'Styczeń'
                WHEN 2 THEN 'Luty'
                WHEN 3 THEN 'Marzec'
                WHEN 4 THEN 'Kwiecień'
                WHEN 5 THEN 'Maj'
                WHEN 6 THEN 'Czerwiec'
                WHEN 7 THEN 'Lipiec'
                WHEN 8 THEN 'Sierpień'
                WHEN 9 THEN 'Wrzesień'
                WHEN 10 THEN 'Październik'
                WHEN 11 THEN 'Listopad'
                WHEN 12 THEN 'Grudzień'
              END -- [Month]
            , Cast( Day(@DateInProcess) as int) -- [Day]
        );
        Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
    END
go
