USE go_explore_travel_agency;
GO

-- old clients
SELECT * FROM Client
WHERE client_pesel in (61043069085,15283071205,48102565063 );

-- new clients
SELECT * FROM Client
WHERE client_pesel in (95100349360,68071914716,87110569670 );

USE go_explore_travel_agency_t2;
GO

-- old clients
SELECT * FROM Client
WHERE client_pesel in (61043069085,15283071205,48102565063 );

-- new clients
SELECT * FROM Client
WHERE client_pesel in (95100349360,68071914716,87110569670 );


