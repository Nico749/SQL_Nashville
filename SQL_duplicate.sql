/* Data cleaning */
SELECT * FROM dbo.[Nashville Housing Data];

/* Check property address where it has null values*/
SELECT PropertyAddress
from dbo.[Nashville Housing Data]
where PropertyAddress is null;

/*Since the property address is linked with the ParcelID, self join the table on the same ParcelID but different 
UniqueId to check if we can fill some of the missing values of PropertyAddress with the corresponding ParcelID */
SELECT first.PropertyAddress, first.ParcelID, second.PropertyAddress, second.ParcelID, ISNULL(first.PropertyAddress, second.PropertyAddress)
from dbo.[Nashville Housing Data] first
join dbo.[Nashville Housing Data] second
on first.ParcelID = second.ParcelID
and first.UniqueID<>second.UniqueID
where first.PropertyAddress is null;

/* Update the table */
Update first
set PropertyAddress = ISNULL(first.PropertyAddress, second.PropertyAddress)
from dbo.[Nashville Housing Data] first
join dbo.[Nashville Housing Data] second
on first.ParcelID = second.ParcelID
and first.UniqueID<>second.UniqueID
where first.PropertyAddress is null;


Update first
set PropertyAddress = ISNULL(first.PropertyAddress, second.PropertyAddress)
from dbo.[Nashville Housing Data] first
join dbo.[Nashville Housing Data] second
on first.ParcelID = second.ParcelID
and first.UniqueID<>second.UniqueID
where first.PropertyAddress is null;

/* Breaking down the address to retrieve -Address, City, State- */

select SUBSTRING (PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
	   SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from dbo.[Nashville Housing Data];

/* Add the new columns to the table and fill them */
ALTER TABLE [Nashville Housing Data]
Add Property_Address Nvarchar(255)

Update [Nashville Housing Data]
SET Property_Address = SUBSTRING (PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

/**/
ALTER TABLE [Nashville Housing Data]
Add PropertyCity Nvarchar(255)

Update [Nashville Housing Data]
SET PropertyCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

/* Find Owner Address*/
select
 PARSENAME(REPLACE(OwnerAddress,',','.'),3), /*Address*/
 PARSENAME(REPLACE(OwnerAddress,',','.'),2), /*City*/
 PARSENAME(REPLACE(OwnerAddress,',','.'),1)  /*State*/
 from dbo.[Nashville Housing Data];

 /*Add the new columns*/
 ALTER TABLE [Nashville Housing Data]
Add Owner_Address Nvarchar(255)

Update [Nashville Housing Data]
SET Owner_Address =  PARSENAME(REPLACE(OwnerAddress,',','.'),3)


 ALTER TABLE [Nashville Housing Data]
Add Owner_City Nvarchar(255)

Update [Nashville Housing Data]
SET Owner_City =  PARSENAME(REPLACE(OwnerAddress,',','.'),2)


 ALTER TABLE [Nashville Housing Data]
Add Owner_State Nvarchar(255)

Update [Nashville Housing Data]
SET Owner_State =  PARSENAME(REPLACE(OwnerAddress,',','.'),1)

/* Replace 0 and 1 with No and Yes in SoldAsVacant*/
select SoldAsVacant,
case 
	when SoldAsVacant = 0 then 'No'
	else 'Yes'
end
from dbo.[Nashville Housing Data];

ALTER TABLE [Nashville Housing Data]
Add Sold_As_Vacant Nvarchar(255)

Update [Nashville Housing Data]
SET Sold_As_Vacant =  
case 
	when SoldAsVacant = 0 then 'No'
	else 'Yes'
end

select * from dbo.[Nashville Housing Data];

/*remove duplicates*/

with RowNumCTE as (
select *,
	ROW_NUMBER () over (
		partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
		order by UniqueID
		)row_num


from dbo.[Nashville Housing Data]
)
select * 
from RowNumCTE
where row_num>1
/* delete some unused column*/

alter table dbo.[Nashville Housing Data]
	drop column OwnerAddress, TaxDistrict, SoldAsVacant

select * from dbo.[Nashville Housing Data]