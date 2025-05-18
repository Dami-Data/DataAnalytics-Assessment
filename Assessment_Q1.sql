-- Query to list owners with at least one savings and one investment plan
-- showing total deposits and counts of each type

select distinct
  u.id as owner_id
  , concat(u.first_name, ' ', u.last_name) as name
  , sum(case when p.is_regular_savings = 1 then 1 else 0 end) as savings_count
  , sum(case when p.is_a_fund = 1 then 1 else 0 end) as investment_count
  , replace(format(sum(sa.confirmed_amount) / 100, 2), ',', '') as total_deposits
from users_customuser u
join plans_plan p on u.id = p.owner_id
join savings_savingsaccount sa on sa.plan_id = p.id
where sa.confirmed_amount > 0
group by 
  u.id
  , u.first_name
  , u.last_name
having 
  sum(case when p.is_regular_savings = 1 then 1 else 0 end) >= 1
  and
  sum(case when p.is_a_fund = 1 then 1 else 0 end) >= 1
order by total_deposits desc;
