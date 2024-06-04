-------------------------------------------------------------------
--Choose one of your favorite films and add it to the "film" table. 
--Fill in rental rates with 4.99 and rental durations with 2 weeks.
-------------------------------------------------------------------


--add my fav film to the list
insert into film (title, description, release_year, language_id, rental_duration, rental_rate)
values (
	'ISLAND'
	, 'Lincoln Six Echo is just like everyone else as he waits to go to the island. But he soon discovers that everything about his existence is a lie and that he and the other inhabitants are human clones.'
	, 2005
	, (select language_id from "language" where lower("name") =  'english')
	, 14
	, 4.99
)
returning *

------------------------------------------------------------------------------
-- Add the actors who play leading roles in your favorite film to the "actor" 
-- and "film_actor" tables (three or more actors in total).
------------------------------------------------------------------------------

insert into actor (first_name, last_name)
values
		('SCARLETT', 'JOHANSSON'),
		('EWAN', 'MCGREGOR'),
		('STEVE', 'BUSCEMI')
returning *

insert into film_actor (actor_id, film_id)
values 	(
			(SELECT actor_id FROM actor WHERE first_name = 'SCARLETT' AND last_name = 'JOHANSSON'), 
			(SELECT film_id FROM film WHERE title = 'ISLAND' AND release_year = 2005)
		), 
		(
			(SELECT actor_id FROM actor WHERE first_name = 'EWAN' AND last_name = 'MCGREGOR'), 
			(SELECT film_id FROM film WHERE title = 'ISLAND' AND release_year = 2005)
		), 
		(
			(SELECT actor_id FROM actor WHERE first_name = 'STEVE' AND last_name = 'BUSCEMI'), 
			(SELECT film_id FROM film WHERE title = 'ISLAND' AND release_year = 2005)
		)
returning *

------------------------------------------------------------------------------
-- Add your favorite movies to any store's inventory.
------------------------------------------------------------------------------
		
insert into inventory (film_id, store_id)
values (
		(select film_id from film where title = 'ISLAND' AND release_year = 2005),
		2
		)
returning *
		



