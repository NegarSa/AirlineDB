CREATE TABLE Country(
	ID int PRIMARY KEY,
	name varchar(50)
)


CREATE TABLE City(
	ID int PRIMARY KEY,
	name varchar(50),
	CountryID int REFERENCES Country(ID) 
)


CREATE TABLE Airport(
	ID int PRIMARY KEY,
	city int REFERENCES City(ID),
	name varchar(300)
)


CREATE TABLE Paths(
	ID int PRIMARY KEY,
	firstAirport int REFERENCES Airport(ID),
	secondAirport int REFERENCES Airport(ID)
)



CREATE TABLE Passengers(
	ID int PRIMARY KEY,
	firstname varchar(50),
	lastname varchar(50),
	city int REFERENCES City(ID)
)


CREATE TABLE Captains(
	ID int PRIMARY KEY,
	firstname varchar(50),
	lastname varchar(50),
	airport int REFERENCES Airport(ID)
)


CREATE TABLE Flights(
	ID int PRIMARY KEY, 
	path int REFERENCES Paths(ID),
	captain int REFERENCES Captains(ID)
)


CREATE TABLE Schedule(
	ID int PRIMARY KEY,
	flight int REFERENCES Flights(ID),
	date varchar(20),
	timeslot int
)


CREATE TABLE Payments(
	ID INT PRIMARY KEY,
	passenger INT REFERENCES Passengers(ID),
	amount numeric(10,2)
)


CREATE TABLE Tickets(
	ID INT PRIMARY KEY, 
	payment INT REFERENCES Payments(ID),
	flight INT REFERENCES Flights(ID),
	showedup int check (showedup in (0, 1))
)



