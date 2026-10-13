/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM DataCleaning..NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDateConverted , CONVERT(Date, SaleDate)
FROM DataCleaning..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)
 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM DataCleaning..NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID

--JOIN
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM DataCleaning.dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address --eliminating the comma
FROM DataCleaning.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



