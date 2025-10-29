SET IDENTITY_INSERT Tour ON;
BULK INSERT dbo.Worker FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\workers.bulk'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\r\n',
    DATAFILETYPE = 'char',
    CODEPAGE = '65001'
);
SET IDENTITY_INSERT Tour OFF;