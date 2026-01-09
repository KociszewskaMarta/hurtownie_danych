USE sample_warehouse;
GO

INSERT INTO [dbo].Junk_D 
    ( [status_oplacenia] )
VALUES 
    ( 'Nie' ),
    ( 'Tak' );

IF NOT EXISTS (SELECT 1 FROM Junk_D WHERE status_oplacenia = 'UNKNOWN')
BEGIN
    INSERT INTO Junk_D (status_oplacenia)
    VALUES ('UNK')
END

GO
