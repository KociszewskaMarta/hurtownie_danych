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

BULK INSERT dbo.Tour FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\tours.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);

BULK INSERT dbo.TourEdition FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\tour_editions.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);

BULK INSERT dbo.Reservation FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\reservations.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);

BULK INSERT dbo.Payment FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\payments.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);
BULK INSERT dbo.ReservationClient FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\reservation_clients.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);
BULK INSERT dbo.ReservationWorker FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\reservation_workers.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);