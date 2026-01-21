## 1. Porównanie liczby sprzedanych wycieczek według typów (relaks, aktywnie, rodzinnie, city-break)

Użyte kolumny z hurtowni: Rezerwacja_F (id_wycieczki, id_junk), Wycieczka_D (typ), Data_D (miesiac), Junk_D (status_oplacenia)

Użycie: WHERE (opłacona), MDX function na hierarchii 

```
([Wycieczka_D].[typ].Members), operacja COUNT
SELECT
  [Measures].[Liczba Sprzedanych Wycieczek] ON COLUMNS,
  [Wycieczka_D].[typ].Members ON ROWS
FROM [Rezerwacja_F]
WHERE ([Junk_D].[status_oplacenia].&[Tak], [Data_D].[Miesiac].CurrentMember, [Data_D].[Miesiac].CurrentMember.PrevMember)``
```

## 2. Porównanie średniej ceny sprzedanych turnusów

Użyte kolumny z hurtowni: Rezerwacja_F (cena_turnusu, id_junk), Data_D (miesiac), Junk_D (status_oplacenia)

Użycie: calculated member ([Measures].[Średnia Cena Turnusu]), WHERE (opłacona), MDX function na hierarchii ([Data_D].[Miesiac].CurrentMember), operacja Avg

```
WITH MEMBER [Measures].[Średnia Cena Turnusu] AS
  Avg([Rezerwacja_F].[id_wycieczki].Members, [Measures].[cena_turnusu])
SELECT
  [Measures].[Średnia Cena Turnusu] ON COLUMNS,
  ([Data_D].[Miesiac].CurrentMember, [Data_D].[Miesiac].CurrentMember.PrevMember) ON ROWS
FROM [Rezerwacja_F]
WHERE ([Junk_D].[status_oplacenia].&[Tak])
```

## 3. Analiza liczby zarezerwowanych wycieczek według destynacji (kraje / regiony)

Użyte kolumny z hurtowni: Rezerwacja_F (id_wycieczki), Wycieczka_D (destynacja), Data_D (miesiac)

Użycie: MDX function na hierarchii ([Wycieczka_D].[destynacja].Members), operacja COUNT

```
SELECT
  [Measures].[Liczba Rezerwacji] ON COLUMNS,
  [Wycieczka_D].[destynacja].Members ON ROWS
FROM [Rezerwacja_F]
WHERE ([Data_D].[Miesiac].CurrentMember, [Data_D].[Miesiac].CurrentMember.PrevMember)
```

## 4. Porównanie liczby nowych klientów (pierwsza rezerwacja) i powracających klientów

Użyte kolumny z hurtowni: Klient_D (czy_nowy), Rezerwacja_F (id_klienta), Data_D (miesiac)

Użycie: calculated member ([Measures].[Liczba Nowych Klientów], [Measures].[Liczba Powracających Klientów]), operacja COUNT, FILTER

```
WITH MEMBER [Measures].[Liczba Nowych Klientów] AS
  COUNT(FILTER([Klient_D].[id_klienta].Members, [Klient_D].[czy_nowy] = "Tak"))
WITH MEMBER [Measures].[Liczba Powracających Klientów] AS
  COUNT(FILTER([Klient_D].[id_klienta].Members, [Klient_D].[czy_nowy] = "Nie"))
SELECT
  {[Measures].[Liczba Nowych Klientów], [Measures].[Liczba Powracających Klientów]} ON COLUMNS,
  ([Data_D].[Miesiac].CurrentMember, [Data_D].[Miesiac].CurrentMember.PrevMember) ON ROWS
FROM [Rezerwacja_F]
```

## 5. Porównanie całkowitych przychodów z rezerwacji w bieżącym i poprzednim miesiącu

Użyte kolumny z hurtowni: Rezerwacja_F (kwota_transakcji, id_junk), Data_D (miesiac), Junk_D (status_oplacenia)

Użycie: calculated member ([Measures].[Suma Przychodu], [Measures].[Średnia Wartość Rezerwacji]), WHERE (opłacona), operacje SUM, Avg

```
WITH MEMBER [Measures].[Suma Przychodu] AS
  SUM([Rezerwacja_F].[id_wycieczki].Members, [Measures].[kwota_transakcji])
WITH MEMBER [Measures].[Średnia Wartość Rezerwacji] AS
  Avg([Rezerwacja_F].[id_wycieczki].Members, [Measures].[kwota_transakcji])
SELECT
  {[Measures].[Suma Przychodu], [Measures].[Średnia Wartość Rezerwacji]} ON COLUMNS,
  ([Data_D].[Miesiac].CurrentMember, [Data_D].[Miesiac].CurrentMember.PrevMember) ON ROWS
FROM [Rezerwacja_F]
WHERE ([Junk_D].[status_oplacenia].&[Tak])
```

## 6. Które kampanie reklamowe (Campaign Name) przyniosły najwyższy współczynnik konwersji

Użyte kolumny z hurtowni: Kampania_F (wspolczynnik_konwersji), Nazwa_kampanii_D (nazwa_kampanii), Data_D (miesiac)

Użycie: TopCount (funkcja Top), WHERE clause, MDX function na hierarchii ([Nazwa_kampanii_D].[nazwa_kampanii].Members)

```
SELECT
  [Measures].[wspolczynnik_konwersji] ON COLUMNS,
  TopCount([Nazwa_kampanii_D].[nazwa_kampanii].Members, 3, [Measures].[wspolczynnik_konwersji]) ON ROWS
FROM [Kampania_F]
WHERE ([Data_D].[Miesiac].CurrentMember)
```

## 7. Jak zmienia się koszt pozyskania klienta (CAC) w poszczególnych kampaniach

Użyte kolumny z hurtowni: Kampania_F (koszt_kampanii, wspolczynnik_konwersji), Nazwa_kampanii_D (nazwa_kampanii), Data_D (miesiac)

Użycie: calculated member ([Measures].[Koszt Pozyskania Klienta]), WHERE clause, operacja dzielenia

```
WITH MEMBER [Measures].[Koszt Pozyskania Klienta] AS
  [Measures].[koszt_kampanii] / [Measures].[wspolczynnik_konwersji]
SELECT
  [Measures].[Koszt Pozyskania Klienta] ON COLUMNS,
  [Nazwa_kampanii_D].[nazwa_kampanii].Members ON ROWS
WHERE ([Data_D].[Miesiac].CurrentMember)
FROM [Kampania_F]
```

## 8. Jakie słowa kluczowe (Keyword) generują największą liczbę kliknięć i najwyższy współczynnik konwersji

Użyte kolumny z hurtowni: Kampania_F (liczba_klikniec, wspolczynnik_konwersji), Slowo_kluczowe_D (slowo_kluczowe), Data_D (miesiac)

Użycie: TopCount (funkcja Top), MDX function na hierarchii ([Slowo_kluczowe_D].[slowo_kluczowe].Members)

```
SELECT
  {[Measures].[liczba_klikniec], [Measures].[wspolczynnik_konwersji]} ON COLUMNS,
  TopCount([Slowo_kluczowe_D].[slowo_kluczowe].Members, 3, [Measures].[liczba_klikniec]) ON ROWS
FROM [Kampania_F]
WHERE ([Data_D].[Miesiac].CurrentMember)
```

## 9. Które kampanie reklamowe generują najwyższe koszty w przeliczeniu na wycieczkę

Użyte kolumny z hurtowni: Kampania_F (koszt_kampanii, id_wycieczki), Nazwa_kampanii_D (nazwa_kampanii), Data_D (miesiac)

Użycie: calculated member ([Measures].[Koszt Na Wycieczkę]), TopCount (funkcja Top), operacja dzielenia

```
WITH MEMBER [Measures].[Koszt Na Wycieczkę] AS
  [Measures].[koszt_kampanii] / COUNT([Kampania_F].[id_wycieczki].Members)
SELECT
  [Measures].[Koszt Na Wycieczkę] ON COLUMNS,
  TopCount([Nazwa_kampanii_D].[nazwa_kampanii].Members, 3, [Measures].[Koszt Na Wycieczkę]) ON ROWS
FROM [Kampania_F]
WHERE ([Data_D].[Miesiac].CurrentMember)
```

## 10. Które typy wycieczek (relaks, aktywnie, rodzinnie, city-break) generują najwyższy współczynnik konwersji (Conversion Rate) w Google Ads

Użyte kolumny z hurtowni: Kampania_F (wspolczynnik_konwersji, id_wycieczki), Wycieczka_D (typ), Data_D (miesiac)

Użycie: TopCount (funkcja Top), MDX function na hierarchii ([Wycieczka_D].[typ].Members)

```
SELECT
  [Measures].[wspolczynnik_konwersji] ON COLUMNS,
  TopCount([Wycieczka_D].[typ].Members, 3, [Measures].[wspolczynnik_konwersji]) ON ROWS
FROM [Kampania_F]
WHERE ([Data_D].[Miesiac].CurrentMember)
```