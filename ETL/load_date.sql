

DECLARE @StartDate date;
DECLARE @EndDate date;

SELECT @StartDate = '2015-1-1', @EndDate = '2025-7-1';

Declare @DateInProcess datetime = @StartDate;

While @DateInProcess <= @EndDate
    BEGIN
        Insert into [dbo].[DimDate] 
        ( [Date]
        , [Year]
        , [Season]
        , [Month]
        , [Day]
        )
        Values ( 
            @DateInProcess -- [Date]
            , Cast( Year(@DateInProcess) as varchar(4)) -- [Year]
            , CASE 
                WHEN Month(@DateInProcess) IN (12, 1, 2) THEN 'Winter'
                WHEN Month(@DateInProcess) IN (3, 4, 5) THEN 'Spring'
                WHEN Month(@DateInProcess) IN (6, 7, 8) THEN 'Summer'
                WHEN Month(@DateInProcess) IN (9, 10, 11) THEN 'Autumn'
              END -- [Season]
            , Cast( DATENAME(month, @DateInProcess) as varchar(10)) -- [Month]
            , Cast( Day(@DateInProcess) as int) -- [Day]
        );
        Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
    END
go
