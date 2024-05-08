drop table if exists order_items;
drop table if exists orders;
drop table if exists products; 

------------------
-- TABLE `orders`
------------------
create table orders (
	o_id serial primary key
	, order_date date not null 
);

insert into orders (order_date) values ('2024-04-01'), ('2024-05-01');
------------------
-- TABLE `products`
------------------
create table products (
	p_name text primary key
	, price money not null
);

insert into products (p_name, price) values ('p1', 500), ('p2', 250);
------------------
-- TABLE `order_items`
------------------
create table order_items (
	order_id int not null
	, product_name text not null
	, amount numeric(7,2) not null default 1 check (amount > 0)
	, primary key (order_id, product_name)
	, constraint fk_order_items_order_id foreign key (order_id) references orders (o_id)
	, constraint fk_order_items_product_name foreign key (product_name) references products (p_name)
);

insert into order_items (order_id, product_name, amount) 
values 
	(1, 'p1', default)
	, (1, 'p2', default)
	, (2, 'p1', 4)
	, (2, 'p2', 2)
;
------------------
-- 3
------------------
-- add `p_id` column to `products` table
alter table products add column p_id serial;
-- add and initialize `product_id` column for `order_items` table
alter table order_items add column product_id int;
update order_items set product_id = (select p.p_id from products as p where product_name = p.p_name);
alter table order_items alter column product_id set not null;
-- add and initialize `price` column for `order_items` table
alter table order_items add column price money; 
update order_items set price = (select p.price from products as p where product_name = p.p_name);
alter table order_items alter column price set not null;
-- add, initialize and constrain `total` column for `order_items` table
alter table order_items add column total money generated always as (amount * price) stored;
alter table order_items add constraint order_items_total_check check (total = amount * price);
-- drop a relation between tables `order_items` and `products`
alter table order_items drop constraint fk_order_items_product_name;
-- alter `products` table (unique for `p_name`column and PK for `p_id` column)
alter table products add constraint unique_p_name unique(p_name);
alter table products drop constraint products_pkey;
alter table products add primary key (p_id);
-- drop existing PK in `order_items` table
alter table order_items drop constraint order_items_pkey;
-- add the relation to `products` table by product id 
alter table order_items add constraint fk_order_items_product_id foreign key (product_id) references products (p_id);
-- add new PK for `order_items` table
alter table order_items add primary key (order_id, product_id);
-- drop 'product_name' column in `order_items` table
alter table order_items drop column product_name;
------------------
-- 4
------------------
-- rename the product
update products set p_name = 'product1' where p_name = 'p1';
-- delete from the 1st order a row where product_name = 'p2'
delete from order_items where order_id = 1 and product_id = (select pr.p_id from products as pr where pr.p_name = 'p2');
-- delete the 2nd order
delete from order_items where order_id = 2; 
-- change the price for product1 and update order_items
update products set price = 5 where p_name = 'product1';
update order_items set price = (select pr.price from products as pr where pr.p_id = product_id);
-- add a new order with current date
insert into orders (order_date) values (current_date);
-- insert info about new order into `order_items` table
insert into order_items (order_id, amount, product_id, price)
	values (3, 3, (select p_id from products where p_name = 'product1'), (select price from products where p_name = 'product1'));