SELECT firstname, lastname FROM Passengers
INNER JOIN City ON City.ID = Passengers.city
INNER JOIN Country ON City.CountryID = Country.ID
WHERE Country.name = 'Iraq'
Order By lastname asc

SELECT
CASE
WHEN amount < 700 THEN 'Economy'
WHEN amount < 1200 and amount > 700 THEN 'Buisness'
WHEN amount > 1200 THEN 'First Class'
END As Category, passenger, amount
FROM Payments



SELECT ID , [0], [1]
FROM(
SELECT Flight.ID ID, Tickets.showedup
FROM Tickets 
INNER JOIN Flights ON Tickets.flight = Flights.ID
)AS s
PIVOT(
COUNT(ID)
FOR showedup IN([0], [1])
)as p


SELECT
CASE GROUPING(firstairport)
WHEN 0 THEN first
WHEN 1 THEN 'All origins'
END AS first,
CASE GROUPING(secondairport)
WHEN 0 THEN second
WHEN 1 THEN'All goals'
END AS Region,
Count(Flights)AS flights 
FROM Flight
INNER JOIN path ON flight.path = path.id
GROUP BY ROLLUP(first, second)


SELECT firstname, lastname, sum(amount) as spent 
FROM Passengers INNER JOIN Payments ON Payments.passenger = Passengers.ID
GROUP BY firstname, lastname
Having min(amount) > 500
