use adashi_staging;
with monthly_user_tx as (
  select distinct
    u.id as owner_id
    , date_format(sa.transaction_date, '%y-%m') as month
    , count(sa.id) as monthly_tx_count
  from users_customuser u
  join savings_savingsaccount sa on u.id = sa.owner_id
  group by 
    u.id
    , month
),

avg_tx_per_user as (
  select 
    owner_id
    , avg(coalesce(monthly_tx_count, 0)) as avg_tx_per_month
  from monthly_user_tx
  group by 
    owner_id
),

categorized_users as (
  select 
    owner_id
    , avg_tx_per_month
    , case
        when avg_tx_per_month >= 10 then 'High Frequency'
        when avg_tx_per_month between 3 and 9 then 'Medium Frequency'
        else 'Low Frequency'
      end as frequency_category
  from avg_tx_per_user
)

select 
  frequency_category
  , count(*) as customer_count
  , round(avg(avg_tx_per_month), 1) as avg_transactions_per_month
from categorized_users
group by 
  frequency_category
order by 
  field(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
