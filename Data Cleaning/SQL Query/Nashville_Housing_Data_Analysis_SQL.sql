-- Cleaning Data using SQL:

SELECT * FROM Covid_Portfolio_Project..NashvilleHosuingData;

-- Standardising the date column:

SELECT SaleDate FROM Covid_Portfolio_Project..NashvilleHosuingData;

ALTER TABLE Covid_Portfolio_Project..NashvilleHosuingData 
ADD SaleDateConverted DATE;

UPDATE Covid_Portfolio_Project..NashvilleHosuingData 
SET SaleDateConverted = CONVERT(DATE, SaleDate)

SELECT SaleDate, SaleDateConverted FROM Covid_Portfolio_Project..NashvilleHosuingData;

-- Populating the Property Address to replace the null values with relevant data:

SELECT ParcelID, PropertyAddress FROM Covid_Portfolio_Project..NashvilleHosuingData
--WHERE PropertyAddress is not null;
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress , ISNULL( a.PropertyAddress, b.PropertyAddress)
FROM Covid_Portfolio_Project..NashvilleHosuingData a 
JOIN Covid_Portfolio_Project..NashvilleHosuingData b
ON a.ParcelID = b.ParcelID AND
a.[UniqueID ]<>b.[UniqueID ] 
WHERE a.PropertyAddress is NULL;

UPDATE a
SET PropertyAddress = ISNULL( a.PropertyAddress, b.PropertyAddress)
FROM Covid_Portfolio_Project..NashvilleHosuingData a 
JOIN Covid_Portfolio_Project..NashvilleHosuingData b
ON a.ParcelID = b.ParcelID AND
a.[UniqueID ]<>b.[UniqueID ] 
WHERE a.PropertyAddress is NULL;

-- Breaking out the Property Address column into separate columns( City, Address, State):

SELECT  PropertyAddress FROM Covid_Portfolio_Project..NashvilleHosuingData;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM Covid_Portfolio_Project..NashvilleHosuingData;

--Adding new columns to the table to split the address column:

ALTER TABLE Covid_Portfolio_Project..NashvilleHosuingData 
ADD Property_Address nvarchar(255);

UPDATE Covid_Portfolio_Project..NashvilleHosuingData 
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE Covid_Portfolio_Project..NashvilleHosuingData 
ADD City nvarchar(255);

UPDATE Covid_Portfolio_Project..NashvilleHosuingData 
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * FROM Covid_Portfolio_Project..NashvilleHosuingData;


-- Similarly, breaking out the Owner Address Column using PARSENAME():

SELECT  OwnerAddress FROM Covid_Portfolio_Project..NashvilleHosuingData;


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3) as Address,
PARSENAME(REPLACE(OwnerAddress, ',','.'),2)as City,
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM Covid_Portfolio_Project..NashvilleHosuingData;

ALTER TABLE Covid_Portfolio_Project..NashvilleHosuingData 
ADD Owner_Address nvarchar(255);

UPDATE Covid_Portfolio_Project..NashvilleHosuingData 
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)


ALTER TABLE Covid_Portfolio_Project..NashvilleHosuingData 
ADD Owner_City nvarchar(255);

UPDATE Covid_Portfolio_Project..NashvilleHosuingData 
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE Covid_Portfolio_Project..NashvilleHosuingData 
ADD Owner_State nvarchar(255);

UPDATE Covid_Portfolio_Project..NashvilleHosuingData 
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT * FROM Covid_Portfolio_Project..NashvilleHosuingData;


--Replacing Y and N in SoldAsVacant Column to YES and NO:

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM Covid_Portfolio_Project..NashvilleHosuingData
GROUP BY SoldAsVacant;

--Using CASE statements to replace:

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM Covid_Portfolio_Project..NashvilleHosuingData;

UPDATE Covid_Portfolio_Project..NashvilleHosuingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END;

-- Removing the Duplicates:

WITH row_num_cte AS (

SELECT *,
ROW_NUMBER() OVER ( 
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			 UniqueID) row_num
FROM Covid_Portfolio_Project..NashvilleHosuingData)
DELETE FROM row_num_cte
WHERE row_num > 1;

SELECT * FROM Covid_Portfolio_Project..NashvilleHosuingData;

-- Deleting unwanted columns:

ALTER TABLE Covid_Portfolio_Project..NashvilleHosuingData
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, SalesDateConverted, TaxDistrict;

SELECT * FROM Covid_Portfolio_Project..NashvilleHosuingData;