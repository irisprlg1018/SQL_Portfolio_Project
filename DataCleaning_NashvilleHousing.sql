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






--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



