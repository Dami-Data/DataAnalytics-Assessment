# DataAnalytics-Assessment
# This repository contains SQL solutions to the four Cowrywise Data Analytics assessment tasks.
Each query is saved in its own file (`Assessment_Q1.sql`, `Assessment_Q2.sql`, `Assessment_Q3.sql`,`Assessment_Q4.sql`).
# use adashi_staging;
Q1: High-Value Customers with Multiple Products
# Approach
The goal is to identify customers who have at least one funded savings plan and at least one funded investment plan, then sort them by total deposits.
- I joined the users_customuser table to the plans_plan table on the user ID to link customers with their plans.
- Then, I joined the savings_savingsaccount table on the plan ID to access transactional data (confirmed deposits).
- Using sum(case when ...), I counted how many savings plans (is_regular_savings = 1) and investment plans (is_a_fund = 1) each customer had.
- I filtered only plans with deposits greater than zero.
- The having clause ensured the user had at least one savings plan and one investment plan.
- Finally, I sorted customers by total deposits converted from kobo to naira for easier reading.
# Challenges
- None encountered.

Q2: Transaction Frequency Analysis
# Approach Explanation
- First, I calculated the number of transactions per user per month by joining the users_customuser and savings_savingsaccount tables, grouping by user and month.
- Then, I calculated the average monthly transaction count per user using an aggregate average.
- Next, I categorized users into three frequency groups based on their average monthly transactions:
- High Frequency: 10 or more transactions/month
- Medium Frequency: 3 to 9 transactions/month
- Low Frequency: 2 or fewer transactions/month
- Finally, I aggregated the count of users in each category and the average transactions per month for that category.
- The output is ordered explicitly to show categories in the order: High, Medium and Low frequency.
# Challenges and Resolutions
- Ensuring the average calculation accounts for months with zero transactions was a consideration. I used coalesce(monthly_tx_count, 0) in   the average calculation to safely handle any nulls.
- Deciding whether to use count(sa.id) vs count(*) or count(u.id) — i chose count(sa.id) to count all transactions accurately.
- I considered using a left join to include users who might have months with zero transactions. However, since the task focuses on calculating the average number of transactions per customer per month, I decided to use an inner join (regular join) to only include users with at least one transaction.
- Using a left join resulted in more users being categorized as "Low Frequency" because it included months where users had no transactions (nulls), lowering their average transaction count.
- Ultimately, I chose inner join because it aligns with the goal to analyze actual transaction activity rather than including inactive months where users did not transact at all.

Question 3: Account Inactivity Alert
# Approach
The goal is to Identify all active accounts (either savings or investments) with no inflow transactions in the last 365 days. This helps the operations team flag potentially dormant accounts.
- I queried the plans_plan and savings_savingsaccount tables.
- Used max(transaction_date) to get the last transaction date for each plan.
- Calculated inactivity days using datediff(current_date, last_transaction_date).
- Filtered for records where inactivity is greater than or equal to 365 days.
- Ensured the output contains only relevant columns like plan_id, owner_id, type, last_transaction_date, and inactivity_days.
- Formatted last_transaction_date as yyyy-mm-dd (without time).
# Challenges
- None encountered.

Question 4: Customer Lifetime Value (CLV) Estimation
# Approach
The goal is to estimate each customer’s lifetime value based on account tenure and transaction volume using a simplified CLV model.
- i queried the users_customuser (for customer info and signup date) and the savings_savingsaccount (for transaction records) and joined on owner_id
- Calculated account tenure using timestampdiff(month, date_joined, current_date).
- Aggregated total transactions per user.
- Applied the CLV formula with a fixed profit rate of 0.1%.
- Formatted the result to always show two decimal places without commas.
# Challenges and Resolutions
- Ensuring CLV values always display in two decimal places (e.g., 15000.00 vs 15000) and resolved using replace(format(...), ',', '').

# SQL Style Guide
Queries in this repository follow the [Brooklyn Data Co SQL Style Guide](https://github.com/brooklyn-data/co/blob/main/sql_style_guide.md) for readability and consistency.

