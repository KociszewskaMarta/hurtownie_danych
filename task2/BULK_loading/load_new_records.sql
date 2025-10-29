USE go_explore_travel_agency_t2;
GO

BULK INSERT dbo.Worker FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\new_workers.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);

BULK INSERT dbo.Client FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\new_clients.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);
BULK INSERT dbo.Reservation FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\new_reservations.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);

BULK INSERT dbo.ReservationClient FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\new_reservation_clients.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);

BULK INSERT dbo.ReservationWorker FROM 'C:\Users\kocis\Desktop\SEM_5\Hurtownie_danych\Labolatoria\repo\hurtownie_danych\task2\python_scripts\generating_data\generating_bulk_files\data\new_reservation_workers.bulk'
WITH (
    FIELDTERMINATOR = '|',
    CODEPAGE = '65001',
    DATAFILETYPE = 'char'
);