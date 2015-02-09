-- Delete the tables if they exist. Set foreign_key_checks = 0 to
-- disable foreign key checks, so the tables may be dropped in
-- arbitrary order.
set foreign_key_checks = 0;
drop table if exists Users;
drop table if exists Reservation;
drop table if exists MoviePerformance;
drop table if exists Movies;
drop table if exists Theatres;
set foreign_key_checks = 1;

create table Users (
userName varchar(20),
name varchar(30) not null,
phone varchar(20) not null,
primary key (userName)
);
create table Movies (
movieName varchar(30),
primary key (movieName)
);
create table Theatres (
theatreName varchar(20),
maxSeats integer not null,
primary key (theatreName)
);
create table MoviePerformance (
performanceDate date,
movieName varchar(30),
theatreName varchar(20),
seats integer not null,
foreign key (theatreName) references Theatres(theatreName),
foreign key (movieName) references Movies(movieName),
primary key (movieName,performanceDate)
);
create table Reservation (
ID mediumint not null auto_increment,
userName varchar(20),
movieName varchar(30),
performanceDate date,
foreign key (userName) references Users(userName),
foreign key (movieName,performanceDate) references MoviePerformance(movieName,performanceDate),
primary key (ID)
);

-- Insert data into the tables.
insert into Users values('ShadowTrizer','Jack Daniel','012983019');
insert into Users values('LightTrizer','Grant whiskey','03424234');
insert into Users values('The crazy rooster','John gustavsson','012921419');
insert into Users values('Anonym','Jonas','1333333337');

insert into Movies values('Shawshank redemption');
insert into Movies values('Click');

insert into Theatres values('Malmö bio',500);
insert into Theatres values('Kino',20);
insert into Theatres values('Johns projektor',5);

insert into MoviePerformance values('2014-12-24','Click','Kino',20);
insert into MoviePerformance values('2014-01-01','Shawshank redemption','Johns projektor',4);

insert into Reservation values(null,'The crazy rooster','Click','2014-12-24');



  
