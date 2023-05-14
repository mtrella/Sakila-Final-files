CREATE TABLE [DimCustomerInfo] (
 [CustomerID] smallint not null,
 [FirstName] varchar(45) not null,
 [LastName] varchar(45) not null,
 [Email] varchar(50) null,
 [AddressID] smallint not null,
 [Active] bit not null,
 [FromDate] datetime not null,
 [ThruDate] datetime not null,
 [RowIndictator] int,
 PRIMARY KEY ([CustomerID])
);
CREATE TABLE [DimCustomerAddressHistory] (
 [AddressHistoryKey] smallint not null,
 [AddressID] smallint not null,
 [CityName] varchar(50) not null,
 [CountryName] varchar(50) not null,
 [DistrictName] varchar(50) not null,
 [PostalCode] varchar(10) null,
 [Phone] varchar(20) not null,
 [FromDate] datetime not null,
 [ThruDate] datetime not null,
 [RowIndictator] int,
 PRIMARY KEY ([AddressHistoryKey])
);


CREATE TABLE [DimFilm] (
 [FilmKey] smallint not null,
 [FilmID] smallint not null,
 [FilmTitle] varchar(255) not null,
 [FilmDesc] varchar(max) null,
 [ReleaseYear] numeric(4,0) null,
 [ReplacementCost] decimal(5,2) not null,
 [FilmLength] smallint null,
 [Rating] varchar(5) null,
 [SpecialFeatures] varchar(100) null,
 PRIMARY KEY ([FilmKey])
);


CREATE TABLE [DimCategory] (
 [CategoryKey] tinyint not null,
 [FilmCategoryID] tinyint not null,
 [CategoryName] varchar(25) not null,
 [LastUpdate] datetime not null,
 PRIMARY KEY ([CategoryKey])
);

CREATE TABLE [DimLanguage] (
 [LanguageKey] tinyint not null,
 [LanguageID] tinyint not null,
 [LanguageName] varchar(25) not null,
 [LastUpdate] datetime not null,
 PRIMARY KEY ([LanguageKey])
);

CREATE TABLE [DimCustomerInfoHist] (
 [CustomerHistID] smallint not null,
 [FirstName] varchar(50) not null,
 [LastName] varchar(50) not null,
 [Email] varchar(50) null,
 [AddressID] smallint not null,
 [Active] bit not null,
 [FromDate] datetime not null,
 [ThruDate] datetime not null,
 [RowIndictator] int,
 PRIMARY KEY ([CustomerHistID])
);
CREATE TABLE [DimStore] (
 [StoreKey] tinyint not null,
 [StoreID] tinyint not null,
 [StoreName] varchar(50) not null,
 [StoreAddress] varchar(50) not null,
 [StorePostalCode] varchar(10) not null,
 [StoreManager] varchar(50) not null,
 PRIMARY KEY ([StoreKey])
);

CREATE TABLE [DimCustomerAddress] (
 [AddressKey] smallint not null,
 [AddressID] smallint not null,
 [CityName] varchar(50) not null,
 [CountryName] varchar(50) not null,
 [DistrictName] varchar(50) not null,
 [PostalCode] varchar(10) null,
 [Phone] varchar(20) not null,
 [FromDate] datetime not null,
 [ThruDate] datetime not null,
 [RowIndictator] int,
 PRIMARY KEY ([AddressKey])
);

CREATE TABLE [FactRentals] (
 [RentalKey] bigint not null,
 [RentalID] bigint not null,
 [PaymentAmount] decimal(5,2) not null,
 [RentalCount] tinyint not null,
 [RentalCharge] decimal(5,2) not null,
 [RentalDuration] tinyint not null,
 [RentalRate] decimal(4,2) not null,
 [RentalDate] datetime not null,
 [ReturnDate] datetime null,
 [RentalLength] smallint not null,
 [LanguageID] tinyint not null,
 [FilmID] smallint not null,
 [CategoryID] tinyint not null,
 [CustomerID] smallint not null,
 [CustomerHistID] smallint not null,
 [AddressID] smallint not null,
 [AddressHistoryID] smallint not null,
 [StoreID] tinyint not null,
 PRIMARY KEY ([RentalKey]),
 CONSTRAINT [FK_FactRentals.AddressID]
 FOREIGN KEY ([AddressID])
 REFERENCES [DimCustomerAddress]([AddressKey]),
 CONSTRAINT [FK_FactRentals.LanguageID]
 FOREIGN KEY ([LanguageID])
 REFERENCES [DimLanguage]([LanguageKey]),
 CONSTRAINT [FK_FactRentals.CustomerHistID]
 FOREIGN KEY ([CustomerHistID])
 REFERENCES [DimCustomerInfoHist]([CustomerHistID]),
 CONSTRAINT [FK_FactRentals.AddressHistoryID]
 FOREIGN KEY ([AddressHistoryID])
 REFERENCES [DimCustomerAddressHistory]([AddressHistoryKey]),
 CONSTRAINT [FK_FactRentals.StoreID]
 FOREIGN KEY ([StoreID])
 REFERENCES [DimStore]([StoreKey]),
 CONSTRAINT [FK_FactRentals.CustomerID]
 FOREIGN KEY ([CustomerID])
 REFERENCES [DimCustomerInfo]([CustomerID]),
 CONSTRAINT [FK_FactRentals.CategoryID]
 FOREIGN KEY ([CategoryID])
 REFERENCES [DimCategory]([CategoryKey]),
 CONSTRAINT [FK_FactRentals.FilmID]
 FOREIGN KEY ([FilmID])
 REFERENCES [DimFilm]([FilmKey])
);