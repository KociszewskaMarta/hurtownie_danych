# KPI i zapytania MDX dla hurtowni danych

## 1. KPI: Liczba rezerwacji – wzrost o co najmniej 0,5% miesięcznie

Wykorzystuje: funkcję hierarchii (PrevMember), operację numeryczną (*1,005)

```mdx
CREATE KPI [Liczba Rezerwacji]
   VALUE = [Measures].[Rezerwacja F Count]
   GOAL = ([Measures].[Rezerwacja F Count], [Data D].[Miesiac].CurrentMember.PrevMember)*1.005
   STATUS = IIF([Measures].[Rezerwacja F Count]>=([Measures].[Rezerwacja F Count], [Data D].[Miesiac].CurrentMember.PrevMember)*1.005,1,0)
   TREND = ([Measures].[Rezerwacja F Count], [Data D].[Miesiac].CurrentMember.PrevMember)*1.005
```

## 2 KPI: Średnia wartość rezerwacji – utrzymanie minimum 5000 PLN

Dopisany problem analityczny

Wykorzystuje: calculated member, funkcję hierarchii (PrevMember)

```mdx
CREATE KPI [Srednia Wartosc Rezerwacji KPI]
   VALUE = [Measures].[Srednia Wartość Rezerwacji]
   GOAL = 5000
   STATUS = IIF([Measures].[Srednia Wartość Rezerwacji] >= 5000, 1, 
             IIF([Measures].[Srednia Wartość Rezerwacji] >= 4500, 0, -1))
   TREND = [Measures].[Srednia Wartość Rezerwacji] - 
           ([Measures].[Srednia Wartość Rezerwacji], [Data D].[Miesiac].CurrentMember.PrevMember)
```
