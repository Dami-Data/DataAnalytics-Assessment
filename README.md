# DataAnalytics-Assessment
# SQL solutions for Cowryrise Data Analytics Assessment
Q1: High-Value Customers with Multiple Products
# Approach
The goal was to identify customers who have at least one funded savings plan and at least one funded investment plan, then sort them by total deposits.
I joined the users_customuser table to the plans_plan table on the user ID to link customers with their plans.
Then, I joined the savings_savingsaccount table on the plan ID to access transactional data (confirmed deposits).
Using SUM(CASE WHEN ...), I counted how many savings plans (is_regular_savings = 1) and investment plans (is_a_fund = 1) each customer had.
I filtered only plans with deposits greater than zero.
The HAVING clause ensured the user had at least one savings plan and one investment plan.
Finally, I sorted customers by total deposits converted from kobo to naira for easier reading.

Q1: Transaction Frequency Analysis
# Approach Explanation
First, I calculated the number of transactions per user per month by joining the users_customuser and savings_savingsaccount tables, grouping by user and month.
Then, I calculated the average monthly transaction count per user using an aggregate average.
Next, I categorized users into three frequency groups based on their average monthly transactions:
High Frequency: 10 or more transactions/month
Medium Frequency: 3 to 9 transactions/month
Low Frequency: 2 or fewer transactions/month
Finally, I aggregated the count of users in each category and the average transactions per month for that category.
The output is ordered explicitly to show categories in the order: High, Medium, Low frequency.
# Challenges and Resolutions
Ensuring the average calculation accounts for months with zero transactions was a consideration. I used COALESCE(monthly_tx_count, 0) in the average calculation to safely handle any nulls.
Deciding whether to use COUNT(sa.id) vs COUNT(*) or COUNT(u.id) — I chose COUNT(sa.id) to count all transactions accurately.
I considered using a LEFT JOIN to include users who might have months with zero transactions. However, since the task focuses on calculating the average number of transactions per customer per month, I decided to use an INNER JOIN (regular JOIN) to only include users with at least one transaction.
Using a LEFT JOIN resulted in more users being categorized as "Low Frequency" because it included months where users had no transactions (nulls), lowering their average transaction count.
Ultimately, I chose INNER JOIN because it aligns with the goal to analyze actual transaction activity rather than including inactive months where users did not transact at all.



