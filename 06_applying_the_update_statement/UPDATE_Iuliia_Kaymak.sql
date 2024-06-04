-------------------------------------------------------------------
--Alter the rental duration and rental rates of the film you inserted before 
--to three weeks and 9.99, respectively.
-------------------------------------------------------------------

update film 
set rental_duration = 21, rental_rate = 9.99
where title = 'ISLAND' and release_year = 2005
returning *

-------------------------------------------------------------------
--Alter any existing customer in the database with at least 10 rental and 10 payment records. 
--Change their personal data to yours (first name, last name, address, etc.). 
--You can use any existing address from the "address" table. 
--Please do not perform any updates on the "address" table, as this can 
-- impact multiple records with the same address.
-------------------------------------------------------------------

update customer 
set first_name = upper('Iuliia'),
	last_name = upper('Kaymak'),
	email = 'kuznetsova.iuliia@student.ehu.lt',
	address_id = 63
where customer_id = 	(select max(customer_id)
							from (
							select 
							c.customer_id
							, count(distinct r.rental_id) as num_rentals
							, count(distinct p.payment_id) as num_of_payments
							from customer as c 
							left join rental as r on r.customer_id = c.customer_id 
							left join payment as p on p.customer_id = c.customer_id 
							group by c.customer_id 
							having count(distinct r.rental_id) >= 10 and count(distinct p.payment_id) >= 10
							)
						)
returning *


------------------------------------------------------------------
--Change the customer's create_date value to current_date.
-------------------------------------------------------------------
update customer 
set create_date = current_date
where first_name = upper('Iuliia') and last_name = upper('Kaymak')
returning *