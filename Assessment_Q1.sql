SELECT DISTINCT
  u.id AS owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) AS savings_count,
  SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) AS investment_count,
  ROUND(SUM(sa.confirmed_amount) / 100, 2) AS total_deposits
FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount sa ON sa.plan_id = p.id
WHERE sa.confirmed_amount > 0
GROUP BY u.id, u.first_name, u.last_name
HAVING 
  SUM(CASE WHEN p.is_regular_savings = 1 THEN 1 ELSE 0 END) >= 1
  AND
  SUM(CASE WHEN p.is_a_fund = 1 THEN 1 ELSE 0 END) >= 1
ORDER BY total_deposits DESC;
