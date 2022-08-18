SELECT * FROM Portfolio.`babyname`;

-- Popular First name and count
SELECT first_name, SUM(num) as Total
FROM babyname
GROUP BY first_name
HAVING COUNT(year) = 101
ORDER BY SUM(num) DESC;

-- Trendy or Timeless
SELECT first_name, SUM(num) as Total,
	CASE WHEN COUNT(year) > 80 THEN 'Classic'
	WHEN COUNT(year) > 50 THEN 'Semi-classic'
	WHEN COUNT(year) > 20 THEN 'Semi-trendy'
	ELSE 'Trendy' END AS popularity_type
FROM babyname
GROUP BY first_name
ORDER BY first_name;

-- Top 10 ranked Male names
SELECT RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank, first_name, SUM(num) as Total
FROM babyname
WHERE sex = 'M'
GROUP BY first_name
LIMIT 10;

-- Top 10 ranked Female names
SELECT RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank, first_name, SUM(num) as Total
FROM babyname
WHERE sex = 'F'
GROUP BY first_name
LIMIT 10;

-- Is the name Charles still popular?
SELECT year, first_name, num, SUM(num) OVER (ORDER BY year) AS cumulative_charles
FROM babyname
WHERE first_name = 'Charles'
ORDER BY year;

-- Top male name each year
SELECT b.year, b.first_name, b.num
FROM babyname AS b
INNER JOIN (
    SELECT year, MAX(num) as max_num
    FROM babyname
    WHERE sex = 'M'
    GROUP BY year) AS subquery 
ON subquery.year = b.year 
    AND subquery.max_num = b.num
ORDER BY year DESC;

-- Top Female name each year
SELECT b.year, b.first_name, b.num
FROM babyname AS b
INNER JOIN (
    SELECT year, MAX(num) as max_num
    FROM babyname
    WHERE sex = 'F'
    GROUP BY year) AS subquery 
ON subquery.year = b.year 
    AND subquery.max_num = b.num
ORDER BY year DESC;

-- Which Male name has been number one for the largest number of years?
WITH tmn AS (
    SELECT b.year, b.first_name, b.num
    FROM babyname AS b
    INNER JOIN (
        SELECT year, MAX(num) num
        FROM babyname
        WHERE sex = 'M'
        GROUP BY year) AS subquery 
    ON subquery.year = b.year 
        AND subquery.num = b.num
    ORDER BY YEAR DESC
    )
SELECT first_name, COUNT(first_name) as count_top_name
FROM tmn
GROUP BY first_name
ORDER BY COUNT(first_name) DESC;

-- Which Female name has been number one for the largest number of years?
WITH tfn AS (
    SELECT b.year, b.first_name, b.num
    FROM babyname AS b
    INNER JOIN (
        SELECT year, MAX(num) num
        FROM babyname
        WHERE sex = 'F'
        GROUP BY year) AS subquery 
    ON subquery.year = b.year 
        AND subquery.num = b.num
    ORDER BY YEAR DESC
    )
SELECT first_name, COUNT(first_name) as count_top_name
FROM tfn
GROUP BY first_name
ORDER BY COUNT(first_name) DESC;