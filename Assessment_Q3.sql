-- Query to find accounts with no transactions in the last 365 days
SELECT 
    pl.id AS plan_id,
    pl.owner_id,
    CASE 
        WHEN pl.is_regular_savings = 1 THEN 'Savings'
        WHEN pl.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(sa.created_on) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(), MAX(sa.created_on)) AS inactivity_days
FROM 
    plans_plan pl
LEFT JOIN 
    savings_savingsaccount sa ON pl.id = sa.plan_id
LEFT JOIN 
    withdrawals_withdrawal ww ON pl.id = ww.plan_id
WHERE 
    pl.is_archived = 0
GROUP BY 
    pl.id, pl.owner_id
HAVING 
    (MAX(sa.created_on) IS NULL OR DATEDIFF(CURRENT_DATE(), MAX(sa.created_on)) > 365)
    AND (MAX(ww.created_on) IS NULL OR DATEDIFF(CURRENT_DATE(), MAX(ww.created_on)) > 365)
ORDER BY 
    inactivity_days DESC;