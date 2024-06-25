--Create a new user with the username "rentaluser" and the password "rentalpassword". 
--Give the user the ability to connect to the database but no other permissions.
create user rentaluser with password 'rentalpassword';
grant connect on database dvdrental to rentaluser;

--Grant "rentaluser" SELECT permission for the "customer" table. 
--Сheck to make sure this permission works correctly—write a SQL query to select all customers.
grant select on table customer to rentaluser;

--Create a new user group called "rental" and add "rentaluser" to the group. 
create role rental;
grant rental to rentaluser;

--Grant the "rental" group INSERT and UPDATE permissions for the "rental" table. 
--Insert a new row and update one existing row in the "rental" table under that role. 
-- Grant SELECT, INSERT, and UPDATE permissions on the "rental" table to the "rental" group
grant select, insert, update on table rental to rental;

--Revoke the "rental" group's INSERT permission for the "rental" table. 
--Try to insert new rows into the "rental" table make sure this action is denied.
revoke insert on table rental from rental;


--Create a personalized role for any customer already existing in the dvd_rental database. The name of the role 
-- name must be client_{first_name}_{last_name} (omit curly brackets). The customer's payment and rental history 
-- must not be empty. Configure that role so that the customer can only access their own data
-- in the "rental" and "payment" tables. Write a query to make sure this user sees only their own data.

create role client_barbara_jones;
alter table rental enable row level security;
alter table payment enable row level security;

--for rental table
create policy rental_client_barbara_jones_policy
on rental
for select
using (customer_id = 4);

grant select on table rental to client_barbara_jones;

alter policy rental_client_barbara_jones_policy
on rental
to client_barbara_jones;

--for payment table
create policy payment_client_barbara_jones_policy
on payment
for select 
using (customer_id = 4);

grant select on table payment to client_barbara_jones;

alter policy payment_client_barbara_jones_policy
on payment
to client_barbara_jones;