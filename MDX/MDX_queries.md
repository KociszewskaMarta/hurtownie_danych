## 1. Porównanie liczby sprzedanych wycieczek według typów (relaks, aktywnie, rodzinnie, city-break)

Użyte kolumny z hurtowni: Rezerwacja_F (id_wycieczki, id_junk), Wycieczka_D (typ), Data_D (miesiac), Junk_D (status_oplacenia)

Użycie: WHERE (opłacona), operacja COUNT

```mdx
SELECT
  [Measures].[Rezerwacja F Count] ON COLUMNS,
  [Wycieczka D].[Typ].[Typ].Members ON ROWS
FROM [Warehouse Travel Agency]
WHERE ([Junk D].[Status Oplacenia].&[Tak])
```

## 2. Porównanie średniej ceny sprzedanych turnusów w bieżącym i poprzednim miesiącu

Użyte kolumny z hurtowni: Rezerwacja_F (cena_turnusu, id_junk), Data_D (miesiac), Junk_D (status_oplacenia)

Użycie: calculated member, WHERE (opłacona), MDX function na hierarchii (PrevMember)

```mdx
WITH 
MEMBER [Measures].[Cena Poprzedni Miesiac] AS
  ([Measures].[Średnia Cena Turnusu], [Data D].[Miesiac].CurrentMember.PrevMember)

SELECT
  {[Measures].[Średnia Cena Turnusu], [Measures].[Cena Poprzedni Miesiac]} ON COLUMNS,
  [Data D].[Hierarchy].[Miesiac].Members ON ROWS
FROM [Warehouse Travel Agency]
WHERE ([Junk D].[Status Oplacenia].&[Tak])
```

## 3. Analiza liczby zarezerwowanych wycieczek według destynacji (kraje / regiony)

Użyte kolumny z hurtowni: Rezerwacja_F (id_wycieczki), Wycieczka_D (destynacja), Data_D (miesiac)

Użycie:

```mdx
SELECT
  [Measures].[Rezerwacja F Count] ON COLUMNS,
  [Wycieczka D].[Destynacja].[Destynacja].Members ON ROWS
FROM [Warehouse Travel Agency]
```

## 4. Porównanie liczby nowych klientów (pierwsza rezerwacja) i powracających klientów

Użyte kolumny z hurtowni: Klient_D (czy_nowy), Rezerwacja_F (id_klienta), Data_D (miesiac)

Użycie: calculated member ([Measures].[Liczba Nowych Klientów], [Measures].[Liczba Powracających Klientów]), operacja COUNT, FILTER
, WHERE clause, operacja COUNT

```mdx
WITH 
MEMBER [Measures].[Liczba Nowych Klientow] AS
  ([Measures].[Rezerwacja F Count], [Klient D].[Czy Nowy].&[Tak])

MEMBER [Measures].[Liczba Powracajacych Klientow] AS
  ([Measures].[Rezerwacja F Count], [Klient D].[Czy Nowy].&[Nie])

SELECT
  {[Measures].[Liczba Nowych Klientow], [Measures].[Liczba Powracajacych Klientow]} ON COLUMNS,
  [Data D].[Hierarchy].[Miesiac].Members ON ROWS
FROM [Warehouse Travel Agency]
```

W przypadku braku nowych klientów w danym miesiącu, wynik będzie NULL dla [Measures].[Liczba Nowych Klientow].

## 5. Porównanie całkowitych przychodów z rezerwacji w bieżącym i poprzednim miesiącu

Użyte kolumny z hurtowni: Rezerwacja_F (kwota_transakcji, id_junk), Data_D (miesiac), Junk_D (status_oplacenia)

Użycie: calculated member, WHERE (opłacona), MDX function na hierarchii (PrevMember), operacja odejmowania

```mdx
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
```

## 6. Które kampanie reklamowe przyniosły najwyższy współczynnik konwersji (Conversion Rate)

Użyte kolumny z hurtowni: Kampania_F (liczba_rezerwacji), Nazwa_kampanii_D (nazwa_kampanii)

Użycie: TopCount (funkcja Top), WHERE clause, MDX function na hierarchii ([Nazwa_kampanii_D].[nazwa_kampanii].Members)

```mdx
SELECT
  [Measures].[Wspolczynnik Konwersji] ON COLUMNS,
  TOPCOUNT([Nazwa Kampanii D].[Nazwa Kampanii].[Nazwa Kampanii].Members, 5, [Measures].[Wspolczynnik Konwersji]) ON ROWS
FROM [Warehouse Travel Agency]
```

## 7. Jak zmienia się koszt na kliknięcie w poszczególnych kampaniach w ujęciu miesięcznym?

Użyte kolumny z hurtowni: Kampania_F (koszt_klikniecia), Nazwa_kampanii_D (nazwa_kampanii), Data_D (miesiac)

Użycie: WHERE clause, MDX function na hierarchii (Members), CROSSJOIN, NONEMPTY

```mdx
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
```

## 8. Jakie słowa kluczowe (Keyword) generują największą liczbę kliknięć i najwyższy współczynnik konwersji?

Użyte kolumny z hurtowni: Keyword_D (keyword), Kampania_F (liczba_klikniec, wspolczynnik_konwersji)

Użycie: TopCount (funkcja Top), MDX function na hierarchii ([Keyword D].[Keyword].[Keyword].Members)

```mdx
SELECT
  [Measures].[Liczba Klikniec] ON COLUMNS,
  TOPCOUNT([Slowo Kluczowe D].[Slowo Kluczowe].[Slowo Kluczowe].Members, 5, [Measures].[Wspolczynnik Konwersji]) ON ROWS
FROM [Warehouse Travel Agency]
```

## 9. Które kampanie reklamowe generują najwyższe koszty w przeliczeniu na wycieczkę (Id wycieczki)?

Użyte kolumny z hurtowni: Kampania_F (koszt_kampanii, id_wycieczki), Nazwa_kampanii_D (nazwa_kampanii)

Użycie: MDX function na hierarchii

```mdx
SELECT
  [Measures].[Koszt Kampanii] ON COLUMNS,
  [Nazwa Kampanii D].[Nazwa Kampanii].[Nazwa Kampanii].Members ON ROWS
FROM [Warehouse Travel Agency]
```

## 10. Które typy wycieczek (relaks, aktywnie, rodzinnie, city-break) generują najwyższy współczynnik konwersji

Użyte kolumny z hurtowni: Wycieczka_D (typ), Kampania_F (wspolczynnik_konwersji)

Użycie: MDX function na hierarchii (Members)

```mdx
SELECT
  [Measures].[Wspolczynnik Konwersji] ON COLUMNS,
  [Wycieczka D].[Typ].[Typ].Members ON ROWS
FROM [Warehouse Travel Agency]
```