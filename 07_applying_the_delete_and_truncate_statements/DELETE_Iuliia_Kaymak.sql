--------------------------------------------------------------------------------------
--Remove a previously inserted film from the inventory and all corresponding rental records.
--------------------------------------------------------------------------------------

delete from inventory cascade
where film_id = (select film_id from film where title = 'ISLAND' and release_year = 2005)

--------------------------------------------------------------------------------------
--Remove any records related to you (as a customer) from all tables 
--except "Customer" and "Inventory"
--------------------------------------------------------------------------------------

BEGIN;

DELETE FROM payment
WHERE rental_id IN (
					SELECT 
					rental_id 
					FROM rental 
					WHERE customer_id = (
											select 
											customer_id 
											from customer 
											where first_name = 'IULIIA' and last_name = 'KAYMAK')
					);

DELETE FROM rental WHERE customer_id = (
										select 
										customer_id 
										from customer 
										where first_name = 'IULIIA' and last_name = 'KAYMAK');

COMMIT;