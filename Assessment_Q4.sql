-- Customer Lifetime Value (CLV) Estimation
-- Profit per transaction assumed as 0.1% of transaction value
use adashi_staging;
with user_tx as (
  select 
    u.id as customer_id
    , concat(u.first_name, ' ', u.last_name) as name
    , timestampdiff(month, u.date_joined, curdate()) as tenure_months
    , count(sa.id) as total_transactions
    , avg(sa.confirmed_amount) / 100 as avg_tx_naira  -- convert kobo to naira
  from users_customuser u
  join savings_savingsaccount sa on sa.owner_id = u.id
  group by 
    u.id
    , u.first_name
    , u.last_name
    , u.date_joined
)

select 
  customer_id
  , name
  , tenure_months
  , total_transactions
  , replace(
      format(
        case 
          when tenure_months = 0 then 0
          else (total_transactions / tenure_months) * 12 * (avg_tx_naira * 0.001)
        end , 2
      ), ',', ''
  ) as estimated_clv
from user_tx
order by estimated_clv desc;
