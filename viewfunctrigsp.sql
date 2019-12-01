---------- Views

CREATE VIEW numNotShowedUp AS (
	SELECT flight, COUNT(ID) num
	FROM Tickets
	WHERE showedup = 0
	GROUP BY flight
)

CREATE VIEW internationalFlights AS (
	SELECT Flights.ID, o1.name firstcountry, o2.name secondcountry
	FROM Flights
	INNER JOIN Paths ON Paths.ID = Flights.path
	INNER JOIN Airport a1 ON Paths.firstAirport = a1.ID
	INNER JOIN Airport a2 ON Paths.secondAirport = a2.ID
	INNER JOIN City c1 ON c1.ID = a1.city
	INNER JOIN City c2 ON c2.ID = a2.city
	INNER JOIN Country o1 ON o1.ID = c1.CountryID
	INNER JOIN Country o2 ON o2.ID = c2.CountryID
	WHERE c1.CountryID != c2.CountryID
)


CREATE VIEW flightAllInfo AS (
	SELECT Flights.ID, a1.name first, a2.name second, Captains.firstname, Captains.lastname, Schedule.date, Schedule.timeslot
	FROM Flights
	INNER JOIN Captains ON Captains.ID = Flights.captain
	INNER JOIN Schedule ON Schedule.flight = Flights.ID
	INNER JOIN Paths ON Paths.ID = Flights.path
	INNER JOIN Airport a1 ON Paths.firstAirport = a1.ID
	INNER JOIN Airport a2 ON Paths.secondAirport = a2.ID
)

------------ Functions
CREATE FUNCTION numPassengersonFlight(@FlightID INT)
RETURNS INT
BEGIN 
	DECLARE @cap INT
	SET @cap = (SELECT COUNT(Payments.passenger)
	FROM Tickets
	INNER JOIN Payments ON Payments.ID = Tickets.payment
	WHERE showedup = 1 AND Tickets.flight = @FlightID)
	RETURN @cap
END


CREATE FUNCTION numSkipped (@passenger INT)
RETURNS INT
BEGIN 
	DECLARE @skip INT
	SET @skip = (SELECT COUNT(Payments.ID)
	FROM Tickets
	INNER JOIN Payments ON Payments.ID = Tickets.payment
	WHERE showedup = 0 AND Payments.passenger = @passenger)
	RETURN @skip
END

CREATE FUNCTION numflightsforcaps (@cap INT)
RETURNS INT
BEGIN 
	DECLARE @num INT
	SET @num = (SELECT COUNT(Flights.ID)
	FROM Flights
	WHERE Flights.captain = @cap)
	RETURN @cap
END


CREATE TABLE logFlight (
	FlightID INT ,
	path INT ,
	date varchar(10) ,
	timeslot INT,
	kind varchar(10)
	PRIMARY KEY (FlightID, path, date, timeslot, kind)
)

--------- Triggers
CREATE TRIGGER changeFlight ON Schedule AFTER UPDATE AS
BEGIN
	INSERT INTO logFlight 
	SELECT Flights.ID, path, i.date, i.timeslot, 'Update Sc' AS kind FROM inserted i
	INNER JOIN Flights ON i.flight = Flights.ID
END

CREATE TRIGGER changeCountry ON Country INSTEAD OF UPDATE, INSERT, DELETE AS 
BEGIN
	PRINT 'Country table cannot be changed or altered'
END

CREATE TRIGGER updateMissed ON Tickets AFTER INSERT AS
BEGIN
	DECLARE @num INT
	SET @num = (SELECT Count(ID)
	FROM inserted
	WHERE showedup = 0)

	UPDATE Passengers
	SET numMissed = numMissed + @num

END


--------- SPs
ALTER TABLE Passengers
ADD numMissed INT

CREATE PROCEDURE updateNumMissed AS
BEGIN
	UPDATE Passengers
	SET numMissed = (SELECT dbo.numSkipped(Passengers.ID) FROM Passengers)
END

CREATE PROCEDURE doneFlights AS
BEGIN
	INSERT INTO logFlight 
	SELECT Flights.ID, path, date, timeslot, 'Done' AS kind FROM Flights
	INNER JOIN Schedule ON Schedule.flight = Flights.ID
	WHERE Cast(date as datetime) < CURRENT_TIMESTAMP
END


CREATE TABLE timeleft (
	FlightID INT ,
	timeleft datetime,
	PRIMARY KEY (FlightID, timeleft)
)


CREATE PROCEDURE timeleftupdate AS
BEGIN
	DELETE FROM timeleft 
	INSERT INTO timeleft 
	SELECT Flights.ID,  DATEDIFF (HOUR , CURRENT_TIMESTAMP, Cast(date as datetime))  timeleft FROM Flights
	INNER JOIN Schedule ON Schedule.flight = Flights.ID
	WHERE Cast(date as datetime) > CURRENT_TIMESTAMP
END
