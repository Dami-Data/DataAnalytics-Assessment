with last_tx as (
  select 
    p.id as plan_id
    , p.owner_id
    , case 
        when p.is_regular_savings = 1 then 'Savings'
        when p.is_a_fund = 1 then 'Investments'
        else 'Others'
      end as type
    , date(max(sa.transaction_date)) as last_transaction_date -- cast to date only, no time
  from plans_plan p
  left join savings_savingsaccount sa on sa.plan_id = p.id
  where p.is_regular_savings = 1 or p.is_a_fund = 1
  group by 
    p.id
    , p.owner_id
    , type
)

select 
  plan_id
  , owner_id
  , type
  , last_transaction_date
  , datediff(current_date(), last_transaction_date) as inactivity_days
from last_tx
where last_transaction_date is not null
  and last_transaction_date <= date_sub(current_date(), interval 365 day)
order by inactivity_days desc;
