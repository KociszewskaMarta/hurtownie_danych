
-- UPDATE dbo.Worker
-- SET role = 'Manager'
-- WHERE worker_pesel = '06291717333';

-- UPDATE dbo.Worker
-- SET role = 'Tour Guide'
-- WHERE worker_pesel = '10270348713';
USE go_explore_travel_agency;
GO

SELECT worker_pesel, first_name, last_name, role
FROM dbo.Worker
WHERE worker_pesel IN ('06291717333', '10270348713');

USE go_explore_travel_agency_t2;
GO

SELECT worker_pesel, first_name, last_name, role
FROM dbo.Worker
WHERE worker_pesel IN ('06291717333', '10270348713');