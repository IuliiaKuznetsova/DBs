--Create a new user with the username "rentaluser" and the password "rentalpassword". 
--Give the user the ability to connect to the database but no other permissions.
create user rentaluser with password 'rentalpassword';
grant connect on database dvdrental to rentaluser;

--Grant "rentaluser" SELECT permission for the "customer" table. 
--Сheck to make sure this permission works correctly—write a SQL query to select all customers.
grant select on table customer to rentaluser;

--Create a new user group called "rental" and add "rentaluser" to the group. 
CREATE ROLE rental;
GRANT rental TO rentaluser;

--Grant the "rental" group INSERT and UPDATE permissions for the "rental" table. 
--Insert a new row and update one existing row in the "rental" table under that role. 
-- Grant SELECT, INSERT, and UPDATE permissions on the "rental" table to the "rental" group
GRANT SELECT, INSERT, UPDATE ON TABLE rental TO rental;

--Revoke the "rental" group's INSERT permission for the "rental" table. 
--Try to insert new rows into the "rental" table make sure this action is denied.
REVOKE INSERT ON TABLE rental FROM rental;


--Create a personalized role for any customer already existing in the dvd_rental database. The name of the role 
-- name must be client_{first_name}_{last_name} (omit curly brackets). The customer's payment and rental history 
-- must not be empty. Configure that role so that the customer can only access their own data
-- in the "rental" and "payment" tables. Write a query to make sure this user sees only their own data.

CREATE ROLE client_barbara_jones;
ALTER TABLE rental ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment ENABLE ROW LEVEL SECURITY;

--for rental table
CREATE POLICY rental_client_barbara_jones_policy
ON rental
FOR SELECT
USING (customer_id = 4);

GRANT SELECT ON TABLE rental TO client_barbara_jones;

ALTER POLICY rental_client_barbara_jones_policy
ON rental
TO client_barbara_jones;

--for payment table
CREATE POLICY payment_client_barbara_jones_policy
ON payment
FOR SELECT
USING (customer_id = 4);

GRANT SELECT ON TABLE payment TO client_barbara_jones;

ALTER POLICY payment_client_barbara_jones_policy
ON payment
TO client_barbara_jones;