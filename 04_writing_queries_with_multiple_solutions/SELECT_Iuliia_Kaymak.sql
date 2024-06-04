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


-----------------------------------------------------------------
/* TASK 2
 * Which five movies were rented more than the others, 
 * 	and what is the expected age of the audience for these movies?
*/
-----------------------------------------------------------------

/*
 * In 1996,the minimum age for NC-17-rated films was raised to 18, by rewording it to "No One 17 and Under Admitted". The ratings used since 1996 are:
 * Rated G: General audiences – All ages admitted.
 * Rated PG: Parental guidance suggested – Some material may not be suitable for children.
 * Rated PG-13: Parents strongly cautioned – Some material may be inappropriate for children under 13.
 * Rated R: Restricted – Under 17 requires accompanying parent or adult guardian.
 * Rated NC-17: Adults only – No one 17 and under admitted.
*/

with num_rent_by_inventory as (
select 
inventory_id, 
count(distinct rental_id) as num_of_rentals
from rental as r 
group by inventory_id
)
, add_film_id as (
select 
i.film_id
, sum(nrbi.num_of_rentals) as num_of_rentals
from num_rent_by_inventory as nrbi
left join inventory as i on nrbi.inventory_id = i.inventory_id
group by i.film_id
order by sum(nrbi.num_of_rentals) desc 
limit 5
)
-- add_film_attributes
select 
afi.*
, f.title as film_title
, f.rating as film_rating
, case
	when f.rating = 'G' then 'All ages admitted.'
	when f.rating  = 'PG' then 'Some material may not be suitable for children.'
	when f.rating  = 'PG-13' then 'Some material may be inappropriate for children under 13.'
	when f.rating  = 'R' then 'Under 17 requires accompanying parent or adult guardian.'
	when f.rating  = 'NC-17' then 'No one 17 and under admitted.'
	else 'Unspecified' end 
	as film_expected_audience
from add_film_id as afi
left join film as f on afi.film_id = f.film_id 


-----------------------------------------------------------------
/* TASK 3
 * Which actors/actresses didn't act for a longer period of time than the others?
*/
-----------------------------------------------------------------
with pivot_actors_table as (
select 
fa.actor_id
, concat(a.first_name, ' ', a.last_name) as actor_full_name 
, count(f.film_id) as num_of_films_participated
, min(f.release_year) as earliest_film_year
, max(f.release_year) as latest_film_year
from film_actor as fa
left join film as f on fa.film_id = f.film_id  
left join actor as a on fa.actor_id = a.actor_id 
group by fa.actor_id, a.first_name, a.last_name  
)
-- getting actor(s) didn't act for a longest period of time
select *
from pivot_actors_table as pat 
where latest_film_year = (
						select min(latest_film_year) 
						from pivot_actors_table
						)
