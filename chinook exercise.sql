-- List all customers. Show only the CustomerId, FirstName and LastName columns

SELECT
    *
FROM
    Customer c



SELECT
    c.CustomerId
    ,c.FirstName
    ,c.LastName
FROM
    Customer c
WHERE c.Country = 'United Kingdom'


-- List customers in the United Kingdom  

-- List customers whose first names begins with an A.
-- Which customers have the initials LK?

SELECT
    c.CustomerId
    ,c.FirstName
    ,c.LastName
FROM
    Customer c
WHERE c.FirstName LIKE 'L%' AND c.LastName LIKE 'K%'

-- Hint: use LIKE and the % wildcard

-- List Customers with an apple email address

SELECT
    c.CustomerId
    ,c.FirstName
    ,c.LastName
    ,c.Email
FROM
    Customer c
WHERE c.Email LIKE '%@apple.%'


-- Which are the corporate customers i.e. those with a value, not NULL, in the Company column?


SELECT
    c.CustomerId
    ,c.FirstName
    ,c.LastName
    ,c.Country
    ,c.Email
    ,c.Company
FROM
    Customer c
WHERE c.Company IS NULL


-- How many customers are in each country.  Order by the most popular country first.

SELECT
    c.Country
    ,COUNT(*) AS [No. of Customers]

FROM
    Customer c
GROUP BY c.Country
ORDER BY [No. of Customers] DESC

-- When was the oldest employee born?  Who is that?

SELECT
    TOP 1
    e.Firstname
    ,e.LastName
    ,e.BirthDate
FROM
    Employee e
ORDER BY BirthDate ASC

SELECT
    Min(e.BirthDate)
FROM
    Employee e



-- List the 10 latest invoices. Include the InvoiceId, InvoiceDate and Total
-- Then  also include the customer full name (first and last name together)

-- List the customers who have spent more than £45

SELECT
    c.FirstName
    ,c.LastName
    ,SUM(i.Total) AS InvTotal
FROM
    Invoice i
    JOIN Customer c ON i.CustomerId=c.CustomerId
GROUP BY c.FirstName
   ,c.LastName
HAVING SUM(i.Total) > 45


-- as a sub query--

SELECT * FROM
(SELECT 
     i.CustomerId
    ,SUM (i.Total) AS InvoiceTotal
FROM
    Invoice i
GROUP BY i.CustomerId
HAVING SUM(i.Total) > 45) AS TopCust

SELECT * FROM Customer WHERE
CustomerId IN
(SELECT 
     i.CustomerId
    ,SUM (i.Total) AS InvoiceTotal
FROM
    Invoice i
GROUP BY i.CustomerId
HAVING SUM(i.Total) > 45) 

-- List the City, CustomerId and LastName of all customers in Paris and London,
-- and the Total of their invoices


-- implement as a table subquery
 
SELECT
    c.FirstName
    ,c.LastName
    ,topCust.InvoiceTotal
FROM
    Customer c JOIN  
(SELECT
    i.CustomerId
    ,SUM(i.Total) AS InvoiceTotal
FROM
Invoice i
GROUP BY i.CustomerId
HAVING  SUM(i.Total) > 45) topCust
ON c.CustomerId = topCust.CustomerId
 
-- implement as a CTE
;
with cte AS
(SELECT
    i.CustomerId
    ,SUM(i.Total) AS InvoiceTotal
FROM
Invoice i
GROUP BY i.CustomerId
HAVING  SUM(i.Total) > 45 )
select
    c.FirstName
    ,c.LastName
    ,cte.InvoiceTotal
from  Customer c JOIN cte on c.CustomerId = cte.CustomerId
 
--implement as temporary tables
 
SELECT
    i.CustomerId
    ,SUM(i.Total) AS InvoiceTotal
    into #TopCust
FROM
Invoice i
GROUP BY i.CustomerId
HAVING  SUM(i.Total) > 45


 Select * from #TopCust JOIN Customer c ON #TopCust.CustomerId = c.CustomerId