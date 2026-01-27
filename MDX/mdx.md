SELECT
  [Measures].[Rezerwacja F Count] ON COLUMNS,
  [Wycieczka D].[Typ].[Typ].Members ON ROWS
FROM [Warehouse Travel Agency]
WHERE ([Junk D].[Status Oplacenia].&[Tak])

WITH 
MEMBER [Measures].[Cena Poprzedni Miesiac] AS
  ([Measures].[Średnia Cena Turnusu], [Data D].[Miesiac].CurrentMember.PrevMember)

SELECT
  {[Measures].[Średnia Cena Turnusu], [Measures].[Cena Poprzedni Miesiac]} ON COLUMNS,
  [Data D].[Hierarchy].[Miesiac].Members ON ROWS
FROM [Warehouse Travel Agency]
WHERE ([Junk D].[Status Oplacenia].&[Tak])

SELECT
  [Measures].[Rezerwacja F Count] ON COLUMNS,
  [Wycieczka D].[Destynacja].[Destynacja].Members ON ROWS
FROM [Warehouse Travel Agency]

WITH 
MEMBER [Measures].[Liczba Nowych Klientow] AS
  ([Measures].[Rezerwacja F Count], [Klient D].[Czy Nowy].&[Tak])

MEMBER [Measures].[Liczba Powracajacych Klientow] AS
  ([Measures].[Rezerwacja F Count], [Klient D].[Czy Nowy].&[Nie])

SELECT
  {[Measures].[Liczba Nowych Klientow], [Measures].[Liczba Powracajacych Klientow]} ON COLUMNS,
  [Data D].[Hierarchy].[Miesiac].Members ON ROWS
FROM [Warehouse Travel Agency]

WITH 
MEMBER [Measures].[Przychod Poprzedni Miesiac] AS
  ([Measures].[Kwota Transakcji], [Data D].[Miesiac].CurrentMember.PrevMember)

MEMBER [Measures].[Zmiana Przychodu] AS
  [Measures].[Kwota Transakcji] - [Measures].[Przychod Poprzedni Miesiac]

SELECT
  {[Measures].[Kwota Transakcji], 
   [Measures].[Przychod Poprzedni Miesiac],
   [Measures].[Zmiana Przychodu],
   [Measures].[Srednia Wartość Rezerwacji]} ON COLUMNS,
  [Data D].[Hierarchy].[Miesiac].Members ON ROWS
FROM [Warehouse Travel Agency]
WHERE ([Junk D].[Status Oplacenia].&[Tak])

SELECT
  [Measures].[Wspolczynnik Konwersji] ON COLUMNS,
  TOPCOUNT([Nazwa Kampanii D].[Nazwa Kampanii].[Nazwa Kampanii].Members, 5, [Measures].[Wspolczynnik Konwersji]) ON ROWS
FROM [Warehouse Travel Agency]

SELECT
  [Measures].[Koszt Na Klikniecie] ON COLUMNS,
  NONEMPTY(
    CROSSJOIN(
      [Nazwa Kampanii D].[Nazwa Kampanii].[Nazwa Kampanii].Members,
      [Data D].[Hierarchy].[Miesiac].Members
    )
  ) ON ROWS
FROM [Warehouse Travel Agency]
WHERE ([Data D].[Rok].&[2025])

SELECT
  [Measures].[Liczba Klikniec] ON COLUMNS,
  TOPCOUNT([Slowo Kluczowe D].[Slowo Kluczowe].[Slowo Kluczowe].Members, 5, [Measures].[Wspolczynnik Konwersji]) ON ROWS
FROM [Warehouse Travel Agency]

SELECT
  [Measures].[Koszt Kampanii] ON COLUMNS,
  [Nazwa Kampanii D].[Nazwa Kampanii].[Nazwa Kampanii].Members ON ROWS
FROM [Warehouse Travel Agency]

SELECT
  [Measures].[Wspolczynnik Konwersji] ON COLUMNS,
  [Wycieczka D].[Typ].[Typ].Members ON ROWS
FROM [Warehouse Travel Agency]