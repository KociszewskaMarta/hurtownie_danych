# KPI dla hurtowni danych (MDX)

## Liczba rezerwacji – wzrost o co najmniej 0,5% miesięcznie
```
CREATE KPI [Liczba Rezerwacji]
   VALUE = ([Measures].[Liczba Rezerwacji])
   GOAL = ([Measures].[Liczba Rezerwacji], [Time].[Month].CurrentMember.PrevMember) * 1.005
   STATUS = IIF([Measures].[Liczba Rezerwacji] >= ([Measures].[Liczba Rezerwacji], [Time].[Month].CurrentMember.PrevMember) * 1.005, 1, 0)
   TREND = ([Measures].[Liczba Rezerwacji], [Time].[Month].CurrentMember.PrevMember)
   DESCRIPTION = "Liczba rezerwacji powinna wzrosnąć o co najmniej 0,5% względem poprzedniego miesiąca."
```

## Suma przychodu – wzrost o co najmniej 0,5% miesięcznie
```
CREATE KPI [Suma Przychodu]
   VALUE = ([Measures].[Suma Przychodu])
   GOAL = ([Measures].[Suma Przychodu], [Time].[Month].CurrentMember.PrevMember) * 1.005
   STATUS = IIF([Measures].[Suma Przychodu] >= ([Measures].[Suma Przychodu], [Time].[Month].CurrentMember.PrevMember) * 1.005, 1, 0)
   TREND = ([Measures].[Suma Przychodu], [Time].[Month].CurrentMember.PrevMember)
   DESCRIPTION = "Suma przychodu powinna wzrosnąć o co najmniej 0,5% względem poprzedniego miesiąca."
```

## Średni koszt pozyskania klienta (CAC) – spadek o 10% kwartalnie
```
CREATE KPI [Średni Koszt Pozyskania Klienta]
   VALUE = ([Measures].[Średni Koszt Pozyskania Klienta])
   GOAL = ([Measures].[Średni Koszt Pozyskania Klienta], [Time].[Quarter].CurrentMember.PrevMember) * 0.9
   STATUS = IIF([Measures].[Średni Koszt Pozyskania Klienta] <= ([Measures].[Średni Koszt Pozyskania Klienta], [Time].[Quarter].CurrentMember.PrevMember) * 0.9, 1, 0)
   TREND = ([Measures].[Średni Koszt Pozyskania Klienta], [Time].[Quarter].CurrentMember.PrevMember)
   DESCRIPTION = "Koszt pozyskania klienta powinien spaść o 10% względem poprzedniego kwartału."
```

## Wskaźnik Klikalności (CTR) – wzrost o 20% w wybranym okresie
```
CREATE KPI [Wskaźnik Klikalności]
   VALUE = ([Measures].[CTR])
   GOAL = ([Measures].[CTR], [Time].[Month].CurrentMember.PrevMember) * 1.2
   STATUS = IIF([Measures].[CTR] >= ([Measures].[CTR], [Time].[Month].CurrentMember.PrevMember) * 1.2, 1, 0)
   TREND = ([Measures].[CTR], [Time].[Month].CurrentMember.PrevMember)
   DESCRIPTION = "Wskaźnik klikalności powinien wzrosnąć o 20% względem poprzedniego miesiąca."
```

## Wskaźnik Konwersji – wzrost o 10% w wybranym okresie
```
CREATE KPI [Wskaźnik Konwersji]
   VALUE = ([Measures].[Współczynnik Konwersji])
   GOAL = ([Measures].[Współczynnik Konwersji], [Time].[Month].CurrentMember.PrevMember) * 1.1
   STATUS = IIF([Measures].[Współczynnik Konwersji] >= ([Measures].[Współczynnik Konwersji], [Time].[Month].CurrentMember.PrevMember) * 1.1, 1, 0)
   TREND = ([Measures].[Współczynnik Konwersji], [Time].[Month].CurrentMember.PrevMember)
   DESCRIPTION = "Wskaźnik konwersji powinien wzrosnąć o 10% względem poprzedniego miesiąca."
```
