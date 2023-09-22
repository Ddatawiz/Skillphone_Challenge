CREATE TABLE CHEMICAL(
index INT,
CDPHId VARCHAR,
ProductName VARCHAR,
CSFId VARCHAR,
CSF VARCHAR,
CompanyId VARCHAR,
CompanyName VARCHAR,
BrandName VARCHAR,
PrimaryCategoryId VARCHAR,
PrimaryCategory VARCHAR,
SubCategoryId VARCHAR,
SubCategory VARCHAR,
CasId VARCHAR,
CasNumber VARCHAR,
ChemicalId VARCHAR,
ChemicalName VARCHAR,
InitialDateReported DATE,
MostRecentDateReported DATE,
DiscontinuedDate DATE,
ChemicalCreatedAt DATE,
ChemicalUpdatedAt DATE,
ChemicalDateRemoved DATE,
ChemicalCount INT
);

SELECT * FROM chemical;

/*1.Find out which chemicals were used the most in cosmetics and personal care products.

To find out which chemicals were used the most in cosmetics and personal care products, 
a database table that contains information about the products 
and their ingredients were provided.*/
SELECT
    ChemicalName,
	PrimaryCategory,
    COUNT(*) AS usage_count
FROM
    chemical
GROUP BY
    ChemicalName, PrimaryCategory
ORDER BY
    usage_count DESC;
	
/*This query will provide a list of chemicals along with the number of times
each chemical has been used in cosmetics and personal care products, with the most frequently
used chemicals appearing at the top of the list.*/
	
/*2.Find out which companies used the most reported chemicals in their cosmetics and personal care products.

To find out which companies used the most reported chemicals in their cosmetics and personal 
care products, a table that contains information about 
the products, their ingredients, and the companies that manufacture them were put together 
in the query to get thye solution.*/

SELECT
    CompanyName,
    PrimaryCategory,
    COUNT(*) AS usage_count
FROM
    chemical
GROUP BY
    CompanyName, PrimaryCategory
ORDER BY
    usage_count DESC;
	
/*This will provide a list of companies along with the chemicals they have used the most in 
their cosmetics and personal care products, with the companies that used a specific chemical 
the most appearing at the top of the list.*/

-- 3.Which brands had chemicals that were removed and discontinued? Identify the chemicals.

SELECT
    BrandName,
    ChemicalName AS discontinued_chemical
FROM
    chemical;

-- 4.Identify the brands that had chemicals which were mostly reported in 2018.

SELECT
    BrandName,
    ChemicalName, MAX(chemicalcount) AS Maxcount
FROM
    chemical
	GROUP BY BrandName, ChemicalName;
-- 5.Which brands had chemicals discontinued and removed?

SELECT
	BrandName,
	DiscontinuedDate,
	ChemicalDateRemoved
FROM
	chemical
WHERE ChemicalDateRemoved IS NOT NULL AND DiscontinuedDate IS NOT NULL
GROUP BY BrandName,DiscontinuedDate,ChemicalDateRemoved
ORDER BY BrandName DESC;

-- 6.Identify the period between the creation of the removed chemicals and when they were actually removed.

SELECT
    ChemicalName,
    ChemicalCreatedAt,
    DiscontinuedDate,
    (DiscontinuedDate - ChemicalCreatedAt) AS removal_period
FROM
    chemical
WHERE DiscontinuedDate IS NOT NULL;

/* This provide a list of discontinued chemicals along with their 
creation dates, discontinuation dates, and the calculated removal periods.*/

-- 7.Can you tell if discontinued chemicals in bath products were removed. 
SELECT
    chemicalname,
    discontinueddate,
    CASE
        WHEN ChemicalCount = 2 THEN 'Removed'
        WHEN ChemicalCount = 1 THEN 'Not Removed'
        ELSE 'Unknown'
    END AS ChemicalCount
FROM
	chemical
WHERE
    PrimaryCategory = 'Bath Products';

/*This provide a list of discontinued chemicals in bath products and 
indicate whether each chemical was removed or not removed based 
on the ChemicalCount flag.*/

-- 8.How long were removed chemicals in baby products used? (Tip: Use creation date to tell)

SELECT
    ProductName,
    chemicalname,
    DiscontinuedDate - ChemicalCreatedAt AS usage_duration
FROM
	chemical
WHERE
    PrimaryCategory = 'Baby Products';

/*This provide a list of removed chemicals in baby products along 
with the duration they were used, calculated as the difference 
between the creation date and the discontinuation date of each chemical.*/

-- 9.Identify the relationship between chemicals that were mostly recently reported and discontinued. 
--(Does most recently reported chemicals equal discontinuation of such chemicals?)

SELECT
	chemicalid,
	discontinueddate,
	MAX(MostRecentDateReported) AS most_recent_report_date,
	CASE
		WHEN MostRecentDateReported = discontinueddate THEN 'Reported and Discontinued'
		ELSE 'Reported but Not Discontinued'
		END AS relationship
FROM
    chemical
	GROUP BY
        chemicalid,discontinueddate,MostRecentDateReported;

/*This query will provide a result that identifies whether the most recently reported 
chemicals were also discontinued or not. The "Reported and Discontinued" label indicates 
that they were reported and discontinued at the same time, while "Reported but Not Discontinued" 
indicates they were reported but not discontinued simultaneously.*/ 

--10.Identify the relationship between CSF and chemicals used in the most manufactured sub categories. 
--(Tip: Which chemicals gave a certain type of CSF in sub categories?)

SELECT
	SubCategoryId,
	SubCategory,
    ChemicalName,
    CSF,
	COUNT(ChemicalId) AS chemical_count
FROM
    chemical
	WHERE CSF IS NOT NULL
	GROUP BY
        SubCategoryId, SubCategory, ChemicalName, CSF
    ORDER BY
        chemical_count DESC;
	
/* This query provide the relationship between CSF 
and chemicals used in the most manufactured sub-category, 
showing the sub-category name, chemical name, and CSF value for
each chemical in that sub-category.*/