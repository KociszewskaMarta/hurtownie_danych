-- Set source and warehouse databases
USE sample_warehouse;
GO

-- Create Reservation_Fact in warehouse if not exists
IF OBJECT_ID('dbo.Reservation_Fact') IS NULL
BEGIN
    CREATE TABLE dbo.Reservation_Fact (
        reservation_id INT PRIMARY KEY,
        reservation_date DATE NOT NULL,
        reservation_status NVARCHAR(20) NOT NULL,
        tour_edition_id INT NOT NULL,
        client_pesel CHAR(11) NOT NULL,
        amount DECIMAL(10,2) NULL,
        payment_id INT NULL
    );
END
GO

-- Insert or update Reservation_Fact from source tables in sample_travel_Agency_data
MERGE INTO dbo.Reservation_Fact AS TT
USING (
    SELECT 
        r.reservation_id,
        r.reservation_date,
        r.reservation_status,
        r.tour_edition_id,
        rc.client_pesel,
        p.amount,
        p.payment_id
    FROM sample_travel_agency_database.dbo.Reservation r
    JOIN sample_travel_agency_database.dbo.ReservationClient rc ON r.reservation_id = rc.reservation_id
    LEFT JOIN sample_travel_agency_database.dbo.Payment p ON r.reservation_id = p.reservation_id
) AS ST
ON TT.reservation_id = ST.reservation_id
WHEN NOT MATCHED THEN
    INSERT (reservation_id, reservation_date, reservation_status, tour_edition_id, client_pesel, amount, payment_id)
    VALUES (ST.reservation_id, ST.reservation_date, ST.reservation_status, ST.tour_edition_id, ST.client_pesel, ST.amount, ST.payment_id)
WHEN MATCHED THEN
    UPDATE SET 
        reservation_date = ST.reservation_date,
        reservation_status = ST.reservation_status,
        tour_edition_id = ST.tour_edition_id,
        client_pesel = ST.client_pesel,
        amount = ST.amount,
        payment_id = ST.payment_id;
GO