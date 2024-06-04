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