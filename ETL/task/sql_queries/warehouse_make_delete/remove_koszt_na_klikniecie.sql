USE sample_warehouse;
GO

-- Usunięcie kolumny koszt_na_klikniecie z tabeli Kampania_F
-- Ta wartość powinna być calculated measure (koszt_kampanii / liczba_klikniec)
ALTER TABLE Kampania_F
DROP COLUMN koszt_na_klikniecie;
GO

PRINT 'Kolumna koszt_na_klikniecie została usunięta z tabeli Kampania_F';
GO
