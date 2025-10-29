BULK INSERT dbo.Worker FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\workers.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);

BULK INSERT dbo.Client FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\clients.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);