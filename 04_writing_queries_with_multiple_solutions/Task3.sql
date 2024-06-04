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
