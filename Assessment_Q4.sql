-- Query to calculate customer lifetime value based on transaction history
WITH customer_metrics AS (
    SELECT 
        cu.id AS customer_id,
        cu.name,
        DATEDIFF(NOW(), cu.date_joined) / 30.0 AS tenure_months,
        COUNT(sa.id) AS total_transactions,
        AVG(sa.confirmed_amount / 100.0) * 0.001 AS avg_profit_per_transaction
    FROM 
        users_customuser cu
    JOIN 
        savings_savingsaccount sa ON cu.id = sa.owner_id
    GROUP BY 
        cu.id, cu.name
)
SELECT 
    customer_id,
    name,
    ROUND(tenure_months) AS tenure_months,
    total_transactions,
    ROUND((total_transactions / tenure_months) * 12 * avg_profit_per_transaction, 2) AS estimated_clv
FROM 
    customer_metrics
WHERE 
    tenure_months > 0
ORDER BY 
    estimated_clv DESC;