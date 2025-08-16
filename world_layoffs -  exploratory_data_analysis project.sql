SELECT * 
FROM layoffs_staging2;
-- check the maximum total laid off in a row
SELECT MAX(total_laid_off)
FROM layoffs_staging2;

-- check the maximum percentage laid off in a row
SELECT MAX(percentage_laid_off)
FROM layoffs_staging2;

-- check the rows where the percentage laid off is 100%, from highest total laid off to lowest
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off desc;

-- check the rows where the percentage laid off is 100%, from highest funds raised million to lowest
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions desc;

-- check the sum of total laid off per company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- check the date range in this dataset
SELECT MIN(`DATE`), MAX(`DATE`)
FROM layoffs_staging2;

-- check the sum of total laid off per industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- check the sum of total laid off per country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- check the sum of total laid off for every date
SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 desc;

-- check the sum of total laid off for every YEAR
SELECT YEAR(`date`) as yearr, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY yearr
ORDER BY 1 desc;

-- check the sum of total_laid_off by stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 desc;

-- check the sum of total laid of by months
SELECT SUBSTRING(`date`,6,2) as `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `MONTH`;


-- check the sum of total laid of by month and year
SELECT SUBSTRING(`date`,1,7) as month_and_year, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY month_and_year
ORDER BY 1;

-- used CTE and window function (rolling_sum) to return total laid off per month and year
-- with a rolling sum on the 3rd column
WITH rolling_total AS(
SELECT SUBSTRING(`date`,1,7) as month_and_year, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY month_and_year
ORDER BY 1)
SELECT month_and_year, total_off,
SUM(total_off) OVER(ORDER BY month_and_year) AS rolling_sum
FROM rolling_total;

--  check the sum of total laid of by company
SELECT company, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY company
ORDER BY 2 DESC;

--  check the sum of total laid of by company and year
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- check the top 5 highest total laid off by company and year
WITH company_year(company, years, total_laid_off) AS (
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY company, YEAR(`date`)
),
company_year_rank AS (
SELECT *, dense_rank() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
where ranking <=5

;






















