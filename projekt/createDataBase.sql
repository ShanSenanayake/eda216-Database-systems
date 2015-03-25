-- Delete the tables if they exist. Set foreign_key_checks = 0 to
-- disable foreign key checks, so the tables may be dropped in
-- arbitrary order.
set foreign_key_checks = 0;
drop table if exists Cookies;
drop table if exists Ingredients;
drop table if exists Batches;
drop table if exists Pallets;
drop table if exists Customers;
drop table if exists Orders;
drop table if exists RecipeEntries;
drop table if exists OrderedPallets;
drop table if exists OrderEntries;
drop table if exists Contracts;
set foreign_key_checks = 1;

create table Cookies (
CookieName varchar(30),
primary key (cookieName)
);
create table Ingredients (
IngredientName varchar(30),
Stock integer not null,
primary key (ingredientName)
);
create table Batches (
CookieName varchar(30),
BatchID integer not null auto_increment,
ProductionDate date,
foreign key (CookieName) references Cookies(CookieName),
primary key (BatchID)
);
create table Pallets (
PalletID integer not null auto_increment,
Location varchar(30) not null,
BatchID integer not null,
isBlocked bool,
foreign key (BatchID) references Batches(BatchID),
primary key (PalletID)
);
create table Customers (
CustomerName varchar(30),
Address varchar(30),
primary key (CustomerName)
);
create table Orders (
ID integer not null auto_increment,
primary key (ID)
);

create table RecipeEntries (
CookieName varchar(30),
IngredientName varchar(30),
Amount integer not null,
foreign key (IngredientName) references Ingredients(IngredientName),
foreign key (CookieName) references Cookies(CookieName),
primary key (IngredientName,CookieName)
);

create table OrderedPallets (
OrderID integer not null,
PalletID integer not null,
foreign key (OrderID) references Orders(ID),
foreign key (PalletID) references Pallets(PalletID),
primary key (OrderID,PalletID)
);

create table OrderEntries (
CookieName varchar(30),
OrderID integer not null,
NbrPallets integer not null,
foreign key (OrderID) references Orders(ID),
foreign key (CookieName) references Cookies(CookieName),
primary key (OrderID,CookieName)
);

create table Contracts (
CustomerName varchar(30),
OrderID integer not null,
foreign key (OrderID) references Orders(ID),
foreign key (CustomerName) references Customers(CustomerName),
primary key (OrderID,CustomerName)
);


-- Insert data into the tables.
insert into Cookies values('Ballerina');
insert into Cookies values('Emelies Super Kakor');
insert into Cookies values('Denhis Bao zi');

insert into Ingredients values('Socker', 500000);
insert into Ingredients values('Mjol', 200000);
insert into Ingredients values('Agg', 300000);
insert into Ingredients values('Kokos', 300400);
insert into Ingredients values('Kakao', 333300);
insert into Ingredients values('Vanlij', 7000);
insert into Ingredients values('Kottfars', 4000);

insert into RecipeEntries values('Ballerina', 'Socker', 30);
insert into RecipeEntries values('Ballerina', 'Mjol', 50);
insert into RecipeEntries values('Ballerina', 'Kakao', 10);
insert into RecipeEntries values('Emelies Super Kakor', 'Kakao', 100);
insert into RecipeEntries values('Emelies Super Kakor', 'Vanlij', 1);
insert into RecipeEntries values('Emelies Super Kakor', 'Agg', 2);
insert into RecipeEntries values('Emelies Super Kakor', 'Mjol', 50);
insert into RecipeEntries values('Emelies Super Kakor', 'Kokos', 40);
insert into RecipeEntries values('Denhis Bao zi', 'Kokos', 33);
insert into RecipeEntries values('Denhis Bao zi', 'Kottfars', 50);
insert into RecipeEntries values('Denhis Bao zi', 'Mjol', 30);
insert into RecipeEntries values('Denhis Bao zi', 'Agg', 3);
insert into RecipeEntries values('Denhis Bao zi', 'Socker', 20);

insert into Batches values('Denhis Bao zi',null,'2015-02-28');
insert into Pallets values(null,'in Stock', (SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'db17' AND   TABLE_NAME   = 'batches')-1,0);
insert into Pallets values(null,'in Stock',  (SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'db17' AND   TABLE_NAME   = 'batches')-1,0);
insert into Pallets values(null,'in Stock',  (SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'db17' AND   TABLE_NAME   = 'batches')-1,0);


insert into Batches values('Denhis Bao zi',null,'2015-02-23');
insert into Pallets values(null,'in Stock', (SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'db17' AND   TABLE_NAME   = 'batches')-1,0);
insert into Pallets values(null,'in Stock', (SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'db17' AND   TABLE_NAME   = 'batches')-1,0);

insert into Batches values('Emelies Super Kakor',null,'2015-03-10');
insert into Pallets values(null,'in Stock', (SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'db17' AND   TABLE_NAME   = 'batches')-1,0);
insert into Pallets values(null,'in Stock', (SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'db17' AND   TABLE_NAME   = 'batches')-1,0);

insert into Batches values('Ballerina',null,'2015-01-10');
insert into Pallets values(null,'in Stock', (SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'db17' AND   TABLE_NAME   = 'batches')-1,0);
insert into Pallets values(null,'in Stock', (SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'db17' AND   TABLE_NAME   = 'batches')-1,0);

insert into Customers values('Maria Persson AB', 'Fagottalley 34B');
insert into Customers values('John projektor AB', 'derpvägen 27');
insert into Customers values('The crazy rooster Inc.', 'Hönsvägen 58');

insert into Orders values(null);
insert into Contracts values('Maria Persson AB',last_insert_id());
insert into OrderEntries values('Emelies Super Kakor',last_insert_id(), 5);
insert into OrderEntries values('Denhis Bao zi',last_insert_id(), 3);

insert into Orders values(null);
insert into Contracts values('John projektor AB',last_insert_id());
insert into OrderEntries values('Ballerina',last_insert_id(),10);
insert into OrderEntries values('Denhis Bao zi',last_insert_id(),100);

  
