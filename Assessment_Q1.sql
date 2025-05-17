-- Query to find customers with at least one funded savings plan AND one funded investment plan
SELECT 
    cu.id AS owner_id,
    cu.name,
    COUNT(DISTINCT CASE WHEN pl.is_regular_savings = 1 THEN pl.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN pl.is_a_fund = 1 THEN pl.id END) AS investment_count,
    SUM(sa.confirmed_amount) / 100.0 AS total_deposits
FROM 
    users_customuser cu
JOIN 
    plans_plan pl ON cu.id = pl.owner_id
JOIN 
    savings_savingsaccount sa ON pl.id = sa.plan_id
GROUP BY 
    cu.id, cu.name
HAVING 
    COUNT(DISTINCT CASE WHEN pl.is_regular_savings = 1 THEN pl.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN pl.is_a_fund = 1 THEN pl.id END) >= 1
ORDER BY 
    total_deposits DESC;