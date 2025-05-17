# DataAnalytics-Assessment

This repository contains my solutions for the SQL Proficiency Assessment for the Data Analyst role at Cowrywise. The assessment evaluates SQL skills through four business-focused queries addressing different analytical scenarios.

## Assessment Overview

The assessment database includes the following tables:
- `users_customuser`: Customer demographic and contact information
- `savings_savingsaccount`: Records of deposit transactions
- `plans_plan`: Records of plans created by customers
- `withdrawals_withdrawal`: Records of withdrawal transactions

## Query Solutions

### Question 1: High-Value Customers with Multiple Products

**Scenario**: Identify customers with both savings and investment plans for cross-selling opportunities.

**Approach**:
- Joined users, plans, and savings tables to connect customers with their plans and transactions
- Used COUNT with CASE statements to differentiate between savings and investment plans
- Applied HAVING clause to filter for customers with at least one of each plan type
- Sorted results by total deposits to identify high-value customers
- Converted amounts from kobo to standard currency by dividing by 100.0

**Challenges**:
- Ensuring the distinction between savings plans (`is_regular_savings = 1`) and investment plans (`is_a_fund = 1`) was correctly implemented
- Making sure the aggregation captured unique plans rather than duplicate counts

### Question 2: Transaction Frequency Analysis

**Scenario**: Analyze transaction frequency to segment customers based on activity levels.

**Approach**:
- Used a CTE (Common Table Expression) to first calculate total transactions and active months for each customer
- Created a second CTE to categorize customers based on their average monthly transaction frequency
- Final query aggregates the results to count customers in each category and calculate average transactions
- Used CASE in the ORDER BY clause to ensure categories are displayed in the correct order

**Challenges**:
- Calculating the correct time period for "months active" using DATEDIFF functions
- Ensuring accurate categorization at the boundary values (e.g., exactly 3 transactions per month)
- Implementing GREATEST(1.0, value) to ensure we never have less than 1 month active

### Question 3: Account Inactivity Alert

**Scenario**: Identify potentially dormant accounts with no transaction activity for over a year.

**Approach**:
- Joined plans table with both savings and withdrawals tables to capture all transaction types
- Used LEFT JOIN to ensure all plans are included, even those without transactions
- Applied GROUP BY to consolidate transactions by plan
- Used HAVING clause with date calculation to identify plans with no activity in the last 365 days
- Included a check for active status (`is_archived = 0`) to exclude plans that were intentionally closed

**Challenges**:
- Handling potential NULL values for accounts with no transaction history
- Ensuring both deposits and withdrawals were considered when determining activity status

### Question 4: Customer Lifetime Value (CLV) Estimation

**Scenario**: Estimate customer lifetime value based on transaction history and account tenure.

**Approach**:
- Created a CTE to calculate key metrics for each customer: tenure, transaction count, and average profit
- Applied the specified CLV formula: (transactions/tenure) * 12 * avg_profit_per_transaction
- Filtered out customers with zero tenure to avoid division by zero errors
- Used ROUND functions to format values appropriately
- Sorted results by estimated CLV in descending order to highlight high-value customers

**Challenges**:
- Converting kobo to standard currency and applying the 0.1% profit rate correctly
- Ensuring the CLV calculation properly handled time periods and transaction frequency

## Key SQL Techniques Demonstrated

- **Table Joins**: Effective use of INNER JOIN and LEFT JOIN to combine data from multiple tables
- **Aggregation**: COUNT, SUM, AVG, and GROUP BY for summarizing data
- **Common Table Expressions (CTEs)**: For breaking down complex queries into manageable steps
- **CASE Statements**: For conditional logic and categorization
- **Date Calculations**: DATEDIFF functions to calculate time periods
- **Data Formatting**: ROUND function and division operations to present values clearly
- **Filter Techniques**: Effective use of WHERE and HAVING clauses for data filtering
- **Sorting**: Appropriate ORDER BY clauses to prioritize results
- **Data Type Handling**: Converting between kobo and standard currency values
- **Null Handling**: Proper handling of NULL values in transaction history