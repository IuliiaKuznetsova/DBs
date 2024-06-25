/* 
-------------- TASK 1 --------------
Create a view called "sales_revenue_by_category_qtr" that shows the film category and total sales revenue for the current quarter. 
The view should only display categories with at least one sale in the current quarter. The current quarter should be determined dynamically.
------------------------------------
*/

create or replace view sales_revenue_by_category_qtr as
select 
cat.name as category_name 
, sum(amount) as revenue
from payment as pay
left join rental as rent on pay.rental_id = rent.rental_id
left join inventory as inv on rent.inventory_id = inv.inventory_id
left join film_category as fc on inv.film_id = fc.film_id
left join category as cat on fc.category_id = cat.category_id
where 
	extract(quarter from pay.payment_date) = extract(quarter from current_date) 
	and extract(year from pay.payment_date) = extract(year from current_date)
group by cat.name
having sum(amount) > 0


/* 
-------------- TASK 2 --------------
Create a query language function called "get_sales_revenue_by_category_qtr" that accepts one parameter 
representing the current quarter and returns the same result as the "sales_revenue_by_category_qtr" view.
------------------------------------
*/

create or replace function get_sales_revenue_by_category_qtr(in qtr int default extract(quarter from current_date))
returns table (category_name text, 
				revenue numeric(5,2))
as $$
select 
cat.name as category_name 
, sum(amount) as revenue
from payment as pay
left join rental as rent on pay.rental_id = rent.rental_id
left join inventory as inv on rent.inventory_id = inv.inventory_id
left join film_category as fc on inv.film_id = fc.film_id
left join category as cat on fc.category_id = cat.category_id
where 
	extract(quarter from pay.payment_date) = qtr
	and extract(year from pay.payment_date) = extract(year from current_date)
group by cat.name
having sum(amount) > 0
$$
language sql;

/* 
-------------- TASK 3 --------------
Create a procedure language function called "new_movie" that takes a movie title as a parameter and inserts a new movie with the given 
title in the film table. The function should generate a new unique film ID, set the rental rate to 4.99, the rental duration to three days, 
the replacement cost to 19.99, the release year to the current year, and "language" as Klingon. The function should also verify that 
the language exists in the "language" table. Then, ensure that no such function has been created before; if so, replace it.
------------------------------------
*/

create or replace function new_movie(p_title text)
	returns void 
	language plpgsql
	as 
$$
declare
    v_language_id integer;
begin
    -- finding language_id for 'Klingon'
    select language_id into v_language_id
    from language
    where name = 'Klingon';
    
    -- checking if the language_id exists 
    if not found then 
        raise exception 'Language "Klingon" does not exist in language table';
    end if; 

    -- inserting a new movie into 'film' table
    insert into film (title, language_id, release_year) -- not explicitly declaring rental_rate = 4.99, rental_duration = 3, replacement_cost = 19.99 as these values are already default values, so we can skip it. 
    values (p_title, v_language_id, extract(year from current_date)::year);

end;
$$;