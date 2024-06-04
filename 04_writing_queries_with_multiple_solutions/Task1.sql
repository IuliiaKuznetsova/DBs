-----------------------------------------------------------------
/* TASK 1
 * Which staff members made the highest revenue for each store 
 * and deserve a bonus for the year 2017?
*/
-----------------------------------------------------------------

-- solution 1 
--by staff_id and year of payment from payments data

with rating_table as (
select 
p.staff_id
, concat(s.first_name, ' ', s.last_name) as staff_full_name
, i.store_id 
, sum(p.amount) as sum_revenue
, row_number() over (partition by i.store_id order by sum(p.amount) desc) as rating
from payment as p 
left join staff as s on s.staff_id = p.staff_id  
left join rental as r on p.rental_id = r.rental_id 
left join inventory as i on r.inventory_id = i.inventory_id 
where extract(year from p.payment_date) = 2017
group by p.staff_id, i.store_id, concat(s.first_name, ' ', s.last_name)
)
select *
from rating_table 
where rating = 1

-- solution 2 by staff_id and rental_date from rentals data
/* 
 * NOT RECOMMENDED TO USE 
 * there are rows where:
 * 1 - rental date is null 
 * 2 - years of rental and payment date are different. 
 * 
 * EXAMPLE
rental_id|year_pay|year_rent|
---------+--------+---------+
        7|    2017|         |
       98|    2017|         |
      919|    2017|     2005|
      307|    2017|     2005|       
 */
with rentals as (
select r.staff_id, r.rental_id, r.inventory_id 
from rental as r
where extract(year from r.rental_date) = 2017
)
, rentals_store as (
select 
r.*
, i.store_id 
from rentals as r
left join inventory as i on r.inventory_id = i.inventory_id 
)
, rentals_store_amount as (
select 
rs.*
, p.amount 
from rentals_store as rs 
left join payment as p on rs.rental_id = p.rental_id 
)
, pivot_table as (
select 
store_id
, staff_id
, sum(amount) as sum_revenue
, row_number() over (partition by store_id order by sum(amount) desc) as rating
from rentals_store_amount
group by store_id, staff_id 
)

select 
pt.*
, s.first_name || ' ' || s.last_name as staff_full_name
from pivot_table as pt
left join staff as s on pt.staff_id = s.staff_id 
where pt.rating = 1