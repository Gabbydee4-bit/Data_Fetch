***Closed-ended question
***What are the top 5 brands by receipts scanned among users 21 and over?

SELECT 
    p.brand, 
    COUNT(DISTINCT t.receipt_id) AS total_receipts
FROM 
    Transactions t
JOIN 
    Users u ON t.user_id = u.id
JOIN 
    Products p ON t.barcode = p.barcode
WHERE 
    DATEDIFF('year', u.birth_date, t.purchase_date) >= 21
GROUP BY 
    p.brand
ORDER BY 
    total_receipts DESC
LIMIT 5;


***Open-ended questions: for these, make assumptions and clearly state them when answering the question.
*** Who are Fetch's power users?
***Assumption: Power users are those in the top 5% of total receipts scanned across all users


WITH UserReceiptCounts AS (
    SELECT 
        t.user_id, 
        COUNT(DISTINCT t.receipt_id) AS receipt_count
    FROM 
        Transactions t
    GROUP BY 
        t.user_id
),
Threshold AS (
    SELECT 
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY receipt_count) AS threshold_value
    FROM 
        UserReceiptCounts
)
SELECT 
    u.id, 
    u.state, 
    u.gender, 
    urc.receipt_count
FROM 
    Users u
JOIN 
    UserReceiptCounts urc ON u.id = urc.user_id
JOIN 
    Threshold t ON urc.receipt_count >= t.threshold_value
ORDER BY 
    urc.receipt_count DESC;
	


***Closed_ended question
***what is the percentage of sales in the Health & Wellness category by generation?
**Assumptions**:
1) The `Health & Wellness` category is identified by `category_1` in the `Products` table.
2) Generations are defined by standard generational cutoff years:
  - Gen Z: Born in 1997 or later
  - Millennials: Born between 1981 and 1996
  - Gen X: Born between 1965 and 1980
  - Baby Boomers: Born between 1946 and 1964
  - Silent Generation: Born before 1946
  
WITH UserGenerations AS (
    SELECT 
        u.id AS user_id,
        CASE 
            WHEN YEAR(u.birth_date) >= 1997 THEN 'Gen Z'
            WHEN YEAR(u.birth_date) BETWEEN 1981 AND 1996 THEN 'Millennials'
            WHEN YEAR(u.birth_date) BETWEEN 1965 AND 1980 THEN 'Gen X'
            WHEN YEAR(u.birth_date) BETWEEN 1946 AND 1964 THEN 'Baby Boomers'
            ELSE 'Silent Generation'
        END AS generation
    FROM 
        Users u
),
CategorySales AS (
    SELECT 
        t.user_id, 
        t.sale
    FROM 
        Transactions t
    JOIN 
        Products p ON t.barcode = p.barcode
    WHERE 
        p.category_1 = 'Health & Wellness'
),
TotalSales AS (
    SELECT 
        generation, 
        SUM(cs.sale) AS health_sales,
        (SELECT SUM(t.sale) FROM Transactions t) AS total_sales
    FROM 
        CategorySales cs
    JOIN 
        UserGenerations ug ON cs.user_id = ug.user_id
    GROUP BY 
        generation
)
SELECT 
    generation,
    ROUND((health_sales / total_sales) * 100, 2) AS health_sales_percentage
FROM 
    TotalSales;