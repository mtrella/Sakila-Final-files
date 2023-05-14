-- create proc's for DIM ETL


/***********************
* Procedure ETL_LoadDimLanguage
* Author: mtrella
* Create Date: 5/1/23
*
* This procedure loads DimLanguage
* This is a Type 0 SCD
* It updates existing rows and inserts new ones
*
* Change log:
* ---------------------------
*
* **********************/
Create or alter proc ETL_LoadDimLanguage
as
Begin

	SET NOCOUNT on

	Select
	l.ODS_language_id,
	l.name,
	l.last_update
	into #src
	from Sakila_ODS_MT.dbo.language l

	--update
	update DimLanguage
	Set LanguageName = src.name
	From DimLanguage as tgt
	Join #src as src
	on tgt.LanguageKey = src.ODS_language_id

	--insert
	Insert into DimLanguage
	(LanguageKey, LanguageID, LanguageName, LastUpdate)
	Select 
	src.ODS_language_id,
	src.ODS_language_id,
	src.name,
	src.last_update
	From #src as src
	left join DimLanguage as tgt
	on src.ODS_language_id = tgt.Languagekey
	where tgt.LanguageKey is null

	drop table #src
End
go

Exec ETL_LoadDimLanguage

go
-- film

/***********************
* Procedure ETL_LoadDimFilm
* Author: mtrella
* Create Date: 5/1/23
*
* This procedure loads DimFilm
* This is a Type 0 SCD
* It updates existing rows and inserts new ones
*
* Change log:
* ---------------------------
*
* **********************/
Create proc ETL_LoadDimFilm
as
Begin

	SET NOCOUNT on

	Select
	f.ODS_film_id,
	f.title,
	f.description,
	f.release_year,
	f.replacement_cost,
	f.length,
	f.rating,
	f.special_features
	into #src
	from Sakila_ODS_MT.dbo.film f

	--update
	update DimFilm
	Set FilmTitle = src.title,
	FilmDesc = src.description,
	ReleaseYear = src.release_year,
	ReplacementCost = src.replacement_cost,
	FilmLength = src.length,
	Rating = src.rating,
	SpecialFeatures = src.special_features
	From DimFilm as tgt
	Join #src as src
	on tgt.FilmKey = src.ODS_film_id

	--insert
	Insert into DimFilm
	(FilmKey, FilmID, FilmTitle, FilmDesc,
	ReleaseYear, ReplacementCost, FilmLength,
	Rating, SpecialFeatures)
	Select 
	src.ODS_film_id,
	src.ODS_film_id,
	src.title,
	src.description,
	src.release_year,
	src.replacement_cost,
	src.length,
	src.rating,
	src.special_features
	From #src as src
	left join DimFilm as tgt
	on src.ODS_film_id = tgt.FilmKey
	where tgt.FilmKey is null

	drop table #src
End
go

Exec ETL_LoadDimFilm
go



/***********************
* Procedure ETL_LoadDimCategory
* Author: mtrella
* Create Date: 5/1/23
*
* This procedure loads LoadDimCategory
* This is a Type 1 SCD
* It updates existing rows and inserts new ones
*
* Change log:
* ---------------------------
*
* **********************/
Create proc ETL_LoadDimCategory
as
Begin

	SET NOCOUNT on

	Select c.ODS_category_id,
	c.name,
	c.last_update
	into #src
	from Sakila_ODS_MT.dbo.category c

	--update
	update DimCategory
	Set CategoryName = src.name
	From DimCategory as tgt
	Join #src as src
	on tgt.CategoryKey = src.ODS_category_id

	--insert
	Insert into DimCategory
	(CategoryKey, CategoryName)
	Select 
	src.ODS_category_id,
	src.name
	From #src as src
	left join DimCategory as tgt
	on src.ODS_category_id = tgt.CategoryKey
	where tgt.CategoryKey is null

	drop table #src
End
go

Exec ETL_LoadDimCategory
go

/***********************
* Procedure ETL_LoadDimCustomerInfo
* Author: mtrella
* Create Date: 5/1/23
*
* This procedure loads LoadDimCustomerInfo
* This is a Type 4 SCD
* 
* It end dates the existing row if changes are found
* and inserts new rows with the changes
*
* Change log:
* ---------------------------
*
* **********************/
Create proc ETL_LoadDimCustomerInfo
as
Begin

	SET NOCOUNT on

	Select c.ODS_customer_id,
	c.first_name,
	c.last_name,
	c.email,
	c.address_id,
	c.active,
	c.create_date,
	c.last_update
	into #src
	from Sakila_ODS_MT.dbo.customer c

	--update
	update DimCustomerInfo
	Set FirstName = src.first_name,
	LastName = src.last_name,
	Email = src.email,
	Active = src.active,
	FromDate = src.create_date
	From DimCustomerInfo as tgt
	Join #src as src
	on tgt.CustomerID = src.ODS_customer_id

	--insert
	Insert into DimCustomerInfo
	(CustomerID, FirstName, LastName, Email, AddressID,
	Active, FromDate, ThruDate)
	Select 
	src.ODS_customer_id,
	src.first_name,
	src.last_name,
	src.email,
	src.address_id,
	src.active,
	src.create_date,
	src.last_update
	From #src as src
	left join DimCustomerInfo as tgt
	on src.ODS_customer_id = tgt.CustomerID
	where tgt.CustomerID is null

	drop table #src
End
go

Exec ETL_LoadDimCustomerInfo
go


/***********************
* Procedure ETL_LoadDimCustomerInfoHist
* Author: mtrella
* Create Date: 5/1/23
*
* This procedure loads LoadDimCustomerInfoHist
* This is a Type 2 SCD
* 
* Updates data from DimCustomerInfo table
* 
*
* Change log:
* ---------------------------
*
* **********************/
Create proc ETL_LoadDimCustomerInfoHist
as
Begin

	SET NOCOUNT on

	Select c.ODS_customer_id,
	c.first_name,
	c.last_name,
	c.email,
	c.address_id,
	c.active,
	c.create_date,
	c.last_update
	into #src
	from Sakila_ODS_MT.dbo.customer c

	--update
	update DimCustomerInfo
	Set FirstName = src.first_name,
	LastName = src.last_name,
	Email = src.email,
	Active = src.active,
	FromDate = src.create_date
	From DimCustomerInfoHist as tgt
	Join #src as src
	on tgt.CustomerHistID = src.ODS_customer_id

	--insert into this table as a base for data
	Insert into DimCustomerInfoHist
	(CustomerHistID, FirstName, LastName, Email, AddressID,
	Active, FromDate, ThruDate)
	Select 
	src.ODS_customer_id,
	src.first_name,
	src.last_name,
	src.email,
	src.address_id,
	src.active,
	src.create_date,
	src.last_update
	From #src as src
	left join DimCustomerInfoHist as tgt
	on src.ODS_customer_id = tgt.CustomerHistID
	where tgt.CustomerHistID is null

	drop table #src
End
go

Exec ETL_LoadDimCustomerInfo
go


/***********************
* Procedure ETL_LoadDimCustomerAddress
* Author: mtrella
* Create Date: 5/1/23
*
* This is a Type 4 SCD
* 
* It end dates the existing row if changes are found
* and inserts new rows with the changes
* 
* 
* Change log:
* ---------------------------
*
* **********************/
Create proc ETL_LoadDimCustomerAddress
as
Begin

	SET NOCOUNT on

	Select a.ODS_address_id,
	a.address,
	a.address2,
	a.district,
	a.city_id,
	a.postal_code,
	a.phone,
	a.last_update,
	c.city,
	co.country
	into #src
	from Sakila_ODS_MT.dbo.address a
	join Sakila_ODS_MT.dbo.city c on a.city_id = c.ODS_city_id
	join Sakila_ODS_MT.dbo.country co on c.country_id = co.ODS_country_id


	--update
	update DimCustomerAddress
	Set CityName = src.city,
	CountryName = src.country,
	DistrictName = src.district,
	PostalCode = src.postal_code,
	Phone = src.phone,
	FromDate = src.last_update
	From DimCustomerAddress as tgt
	Join #src as src
	on tgt.AddressKey = src.ODS_address_id

	--insert into this table as a base for data
	Insert into DimCustomerAddress
	(AddressKey, AddressID, CityName, CountryName, DistrictName,
	PostalCode, Phone, FromDate)
	Select 
	src.ODS_address_id, 
	src.ODS_address_id,
	src.city,
	src.country,
	src.district,
	src.postal_code,
	src.phone,
	src.last_update
	From #src as src
	left join DimCustomerAddress as tgt
	on src.ODS_address_id = tgt.AddressKey
	where tgt.AddressKey is null

	drop table #src
End
go

Exec ETL_LoadDimCustomerAddress
go

/***********************
* Procedure ETL_LoadDimCustomerAddressHist
* Author: mtrella
* Create Date: 5/1/23
*
* This is a Type 4 SCD
* 
* It end dates the existing row if changes are found
* and inserts new rows with the changes
* 
* 
* Change log:
* ---------------------------
*
* **********************/
Create proc ETL_LoadDimCustomerAddressHist
as
Begin

	SET NOCOUNT on

	Select a.ODS_address_id,
	a.address,
	a.address2,
	a.district,
	a.city_id,
	a.postal_code,
	a.phone,
	a.last_update,
	c.city,
	co.country
	into #src
	from Sakila_ODS_MT.dbo.address a
	join Sakila_ODS_MT.dbo.city c on a.city_id = c.ODS_city_id
	join Sakila_ODS_MT.dbo.country co on c.country_id = co.ODS_country_id


	--update
	update DimCustomerAddressHistory
	Set CityName = src.city,
	CountryName = src.country,
	DistrictName = src.district,
	PostalCode = src.postal_code,
	Phone = src.phone,
	FromDate = src.last_update
	From DimCustomerAddressHistory as tgt
	Join #src as src
	on tgt.AddressHistoryKey = src.ODS_address_id

	--insert into this table as a base for data
	Insert into DimCustomerAddress
	(AddressKey, AddressID, CityName, CountryName, DistrictName,
	PostalCode, Phone, FromDate)
	Select 
	src.ODS_address_id,
	src.ODS_address_id,
	src.city,
	src.country,
	src.district,
	src.postal_code,
	src.phone,
	src.last_update
	From #src as src
	left join DimCustomerAddressHistory as tgt
	on src.ODS_address_id = tgt.AddressHistoryKey
	where tgt.AddressHistoryKey is null

	drop table #src
End
go

Exec ETL_LoadDimCustomerAddressHist
go



/***********************
* Procedure ETL_LoadDimStore
* Author: mtrella
* Create Date: 5/1/23
*
* This is a Type 1 SCD
* 
* It updates existing rows and inserts new ones
*
* 
* Change log:
* ---------------------------
*
* **********************/
Create proc ETL_LoadDimStore
as
Begin

	SET NOCOUNT on

	Select s.ODS_store_id,
	a.address,
	a.postal_code
	into #src
	from Sakila_ODS_MT.dbo.store s
	join Sakila_ODS_MT.dbo.address a on s.address_id = a.ODS_address_id


	--update
	update DimStore
	Set StoreAddress = src.address,
	StorePostalCode = src.postal_code
	From DimStore as tgt
	Join #src as src
	on tgt.StoreKey = src.ODS_store_id

	--insert into this table as a base for data
	Insert into DimStore
	(StoreKey, StoreID, StoreAddress, StorePostalCode)
	Select 
	src.ODS_store_id,
	src.ODS_store_id,
	src.address,
	src.postal_code
	From #src as src
	left join DimStore as tgt
	on src.ODS_store_id = tgt.StoreKey
	where tgt.StoreKey is null

	drop table #src
End
go

Exec ETL_LoadDimStore
go


/***********************
* Procedure ETL_LoadDimRentals
* Author: mtrella
* Create Date: 5/1/23
*
* 
* 
* 
* Change log:
* ---------------------------
*
* **********************/
Create proc ETL_LoadFactRentals
as
Begin

	SET NOCOUNT on
	-- pull data into src

	Select r.ODS_rental_id,
	p.amount,
	f.rental_duration,
	f.rental_rate,
	f.last_update,
	f.length,
	l.LanguageKey,
	f.ODS_film_id as 'FilmID',
	c.CategoryKey as 'CategoryID',
	r.customer_id as 'CustomerID',
	a.ODS_address_id as 'AddressID',
	ca.AddressHistoryKey as 'AddressHistoryID',
	s.StoreKey as 'StoreID'
	into #src
	from Sakila_ODS_MT.dbo.rental r
	join Sakila_ODS_MT.dbo.payment p on r.ODS_rental_id = p.rental_id
	join Sakila_ODS_MT.dbo.film f on r.film_id = f.ODS_film_id
	join Sakila_ODS_MT.dbo.address a on r.address_id = a.ODS_address_id
	left join DimLanguage l on f.language_id = l.LanguageKey
	left join DimCategory c on f.category_id = c.CategoryKey
	left join DimCustomerAddressHistory ca on r.address_id = ca.AddressHistoryKey
	left join DimStore s on r.store_id = s.StoreKey

	--update
	update FactRentals
	Set RentalKey = src.ODS_rental_id,
	RentalID = src.ODS_rental_id,
	PaymentAmount = src.amount,
	RentalDuration = src.rental_duration,
	RentalRate = src.rental_rate,
	RentalDate = src.last_update,
	RentalLength = src.length,
	LanguageID = src.LanguageKey,
	FilmID = src.FilmID,
	CategoryID = src.CategoryID,
	CustomerID = src.CustomerID,
	CustomerHistID = src.CustomerID,
	AddressID = src.AddressID,
	AddressHistoryID = src.AddressHistoryID,
	StoreID = src.StoreID
	From FactRentals as tgt
	Join #src as src
	on tgt.RentalKey = src.ODS_rental_id

	--insert into this table as a base for data
	Insert into FactRentals
	(RentalKey, RentalID, PaymentAmount, RentalDuration, RentalRate,
	RentalDate, RentalLength, LanguageID, FilmID, CategoryID,
	CustomerID, CustomerHistID, AddressID, AddressHistoryID,
	StoreID)
	Select 
	src.ODS_rental_id,
	src.ODS_rental_id,
	src.amount,
	src.rental_duration,
	src.rental_rate,
	src.last_update,
	src.length,
	src.LanguageKey,
	src.FilmID,
	src.CategoryID,
	src.CustomerID,
	src.CustomerID,
	src.AddressID,
	src.AddressHistoryID,
	src.StoreID
	From #src as src
	left join FactRentals as tgt
	on src.ODS_rental_id = tgt.RentalKey
	where tgt.RentalKey is null

	drop table  #src
End
go

Exec ETL_LoadFactRentals
go

/***********************
* Procedure ETL_Control
* Author: mtrella
* Create Date: 5/9/23
*
* This procedure calls all the ETL Procedures in order
*
* Change log:
* ---------------------------
*
* **********************/

create or alter procedure ETL_Control
as
Begin
	Set NOCOUNT on 

	begin try
		Exec ETL_LoadDimLanguage
		Exec ETL_LoadDimFilm
		Exec ETL_LoadDimCategory
		Exec ETL_LoadDimCustomerInfo
		Exec ETL_LoadDimCustomerInfoHist
		Exec ETL_LoadDimCustomerAddress
		Exec ETL_LoadDimCustomerAddressHist
		Exec ETL_LoadDimStore
		Exec ETL_LoadFactRentals
	End Try
	Begin Catch
		;throw;
	End Catch
End
go

Exec ETL_Control