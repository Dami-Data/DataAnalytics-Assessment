WITH monthly_user_tx AS (
  SELECT DISTINCT
    u.id AS owner_id
    , DATE_FORMAT(sa.transaction_date, '%Y-%m') AS month
    , COUNT(sa.id) AS monthly_tx_count
  FROM users_customuser u
  JOIN savings_savingsaccount sa ON u.id = sa.owner_id
  GROUP BY 
    u.id
    , month
),

avg_tx_per_user AS (
  SELECT 
    owner_id
    , AVG(COALESCE(monthly_tx_count, 0)) AS avg_tx_per_month
  FROM monthly_user_tx
  GROUP BY 
    owner_id
),

categorized_users AS (
  SELECT 
    owner_id
    , avg_tx_per_month
    , CASE
        WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
        WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
     END AS frequency_category
  FROM avg_tx_per_user
)

SELECT 
  frequency_category
  , COUNT(*) AS customer_count
  , ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM categorized_users
GROUP BY 
  frequency_category
ORDER BY 
  FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
