-- Query to calculate average transactions per customer per month and categorize them
WITH customer_transactions AS (
    SELECT 
        cu.id AS customer_id,
        COUNT(sa.id) AS total_transactions,
        GREATEST(1.0, DATEDIFF(CURRENT_DATE(), cu.date_joined) / 30.0) AS months_active
        -- Using GREATEST(1.0, value) to ensure we never have less than 1 month active
        -- Replaced JULIANDAY with DATEDIFF for MySQL compatibility
    FROM 
        users_customuser cu
    JOIN 
        savings_savingsaccount sa ON sa.owner_id = cu.id
    GROUP BY 
        cu.id
),
frequency_categorized AS (
    SELECT 
        CASE 
            WHEN (total_transactions / months_active) >= 10 THEN 'High Frequency'
            WHEN (total_transactions / months_active) BETWEEN 3 AND 9.99 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        customer_id,
        total_transactions / months_active AS transactions_per_month
    FROM 
        customer_transactions
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    frequency_categorized
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        WHEN frequency_category = 'Low Frequency' THEN 3
    END;