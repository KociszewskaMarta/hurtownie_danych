USE HD_warhouse_real_data
GO

-- ładowanie wymiaru Wycieczka_D z bazy źródłowej
INSERT INTO Wycieczka_D (nazwa_wycieczki, destynacja, typ)
SELECT DISTINCT
    t.name AS nazwa_wycieczki,
    t.destination AS destynacja,
    CASE t.tour_type
        WHEN 'Relax' THEN 'relaks'
        WHEN 'Active' THEN 'aktywnie'
        WHEN 'Family' THEN 'rodzinne'
        WHEN 'City-break' THEN 'city-break'
        ELSE 'relaks'
    END AS typ
FROM go_explore_travel_agency.dbo.Tour t
WHERE NOT EXISTS (
    SELECT 1 FROM Wycieczka_D w
    WHERE w.nazwa_wycieczki = t.name
    AND w.destynacja = t.destination
);
GO