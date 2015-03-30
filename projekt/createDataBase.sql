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
DeliveryDate date,
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
primary key (OrderID)
);


-- Insert data into the tables.
insert into Cookies values('Ballerina');
insert into Cookies values('Emelies Super Kakor');
insert into Cookies values('Denhis Bao zi');
insert into Cookies values('Nut ring');
insert into Cookies values('Nut cookie');
insert into Cookies values('Amneris');
insert into Cookies values('Tango');
insert into Cookies values('Almond Delight');
insert into Cookies values('Berliner');

insert into Ingredients values('Sugar', 500000);
insert into Ingredients values('Flour', 200000);
insert into Ingredients values('Butter', 200000);
insert into Ingredients values('Icing sugar', 200000);
insert into Ingredients values('Nuts', 200000);
insert into Ingredients values('Marzipan', 200000);
insert into Ingredients values('Sodium bicarbonate', 200000);
insert into Ingredients values('Cinnamon', 200000);
insert into Ingredients values('Egg', 300000);
insert into Ingredients values('Kokos', 300400);
insert into Ingredients values('Chocolate', 333300);
insert into Ingredients values('Vanlij', 7000);
insert into Ingredients values('Kottfars', 4000);

insert into RecipeEntries values('Ballerina', 'Suger', 30);
insert into RecipeEntries values('Ballerina', 'Flour', 50);
insert into RecipeEntries values('Ballerina', 'Chocolate', 10);
insert into RecipeEntries values('Emelies Super Kakor', 'Chocolate', 100);
insert into RecipeEntries values('Emelies Super Kakor', 'Vanlij', 1);
insert into RecipeEntries values('Emelies Super Kakor', 'Egg', 2);
insert into RecipeEntries values('Emelies Super Kakor', 'Flour', 50);
insert into RecipeEntries values('Emelies Super Kakor', 'Kokos', 40);
insert into RecipeEntries values('Denhis Bao zi', 'Kokos', 33);
insert into RecipeEntries values('Denhis Bao zi', 'Kottfars', 50);
insert into RecipeEntries values('Denhis Bao zi', 'Flour', 30);
insert into RecipeEntries values('Denhis Bao zi', 'Egg', 3);
insert into RecipeEntries values('Denhis Bao zi', 'Sugar', 20);
insert into RecipeEntries values('Nut ring', 'Flour', 50);
insert into RecipeEntries values('Nut ring', 'Butter', 50);
insert into RecipeEntries values('Nut ring', 'Icing sugar', 50);
insert into RecipeEntries values('Nut ring', 'Nuts', 50);
insert into RecipeEntries values('Nut cookie', 'Nuts', 50);
insert into RecipeEntries values('Nut cookie', 'Sugar', 50);
insert into RecipeEntries values('Nut cookie', 'Egg', 1);
insert into RecipeEntries values('Nut cookie', 'Chocolate', 50);
insert into RecipeEntries values('Amneris', 'Flour', 50);
insert into RecipeEntries values('Amneris', 'Marzipan', 50);
insert into RecipeEntries values('Amneris', 'Butter', 50);
insert into RecipeEntries values('Amneris', 'Egg', 1);
insert into RecipeEntries values('Tango', 'Butter', 50);
insert into RecipeEntries values('Tango', 'Sugar', 50);
insert into RecipeEntries values('Tango', 'Flour', 50);
insert into RecipeEntries values('Tango', 'Sodium bicarbonate', 50);
insert into RecipeEntries values('Tango', 'Vanilla', 50);
insert into RecipeEntries values('Almond delight', 'Butter', 50);
insert into RecipeEntries values('Almond delight', 'Sugar', 50);
insert into RecipeEntries values('Almond delight', 'Nuts', 50);
insert into RecipeEntries values('Almond delight', 'Flour', 50);
insert into RecipeEntries values('Almond delight', 'Cinnamon', 50);
insert into RecipeEntries values('Berliner', 'Flour', 50);
insert into RecipeEntries values('Berliner', 'Butter', 50);
insert into RecipeEntries values('Berliner', 'Icing sugar', 50);
insert into RecipeEntries values('Berliner', 'Egg', 1);
insert into RecipeEntries values('Berliner', 'Vanilla', 50);
insert into RecipeEntries values('Berliner', 'Chocolate', 50);

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
insert into Customers values('Fredrik Folkersson AB', 'Spartavägen 47F');
insert into Customers values('John projektor AB', 'derpvägen 27');
insert into Customers values('The crazy rooster Inc.', 'Hönsvägen 58');

insert into Orders values(null);
insert into Contracts values('Maria Persson AB',last_insert_id());
insert into OrderEntries values('Emelies Super Kakor',last_insert_id(), 5);
insert into OrderEntries values('Denhis Bao zi',last_insert_id(), 3);
insert into OrderedPallets values(last_insert_id(),1, '2013-02-05');
update Pallets set location = (select Address from Customers natural join Contracts where OrderID = last_insert_id()) where PalletId = 1;


insert into Orders values(null);
insert into Contracts values('John projektor AB',last_insert_id());
insert into OrderEntries values('Ballerina',last_insert_id(),10);
insert into OrderEntries values('Denhis Bao zi',last_insert_id(),100);

  
