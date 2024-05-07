-- create database climbing_club_2; 

--------------------------------------
-- DROP EXISTING TABLES 
--------------------------------------
drop table if exists climbers_payments;
drop table if exists enrollments;
drop table if exists tours;
drop table if exists routes;
drop table if exists tour_statuses;
drop table if exists accomodation_companies;
drop table if exists transport_companies;
drop table if exists levels;
drop table if exists mountains;
drop table if exists guides;
drop table if exists climbers;
--------------------------------------
-- TABLE 1 
--------------------------------------
create table climbers 
(
	climber_id serial primary key
	, climber_first_name char(100) not null
	, climber_last_name char(100) not null
	, climber_gender char(50) check (climber_gender in ('Man', 'Woman', 'Non-Binary'))
	, climber_date_of_birth date check (climber_date_of_birth <= current_date) not null
	, climber_country char(100) 
	, climber_city char(100)
	, climber_street_address char(250)
	, climber_zip_code char(25)
	, climber_email char(250)
	, climber_phone_number char(50)	
);
insert into climbers (
	climber_first_name
	, climber_last_name
	, climber_gender
	, climber_date_of_birth
	, climber_country
	, climber_city
	, climber_street_address
	, climber_zip_code
	, climber_email
	, climber_phone_number
) values 
	('John', 'Smith', 'Man', '1996-01-23', 'USA', 'Dallas', '720 W Mockingbird Ln', '75247', 'john.smith@gmail.com', '+12146880800')
	, ('Jenny', 'Ferguisson', 'Woman', '1985-03-31', 'Sweden', 'Stockholm', 'Bryggargatan 10', '11121', 'jenny_ferg01@gmail.com', '+46735908857')
	, ('Polly', 'Miller', 'Non-Binary', '2004-12-13', 'Germany', 'Munich', 'Blumenstraße 4', '80331', 'polly_molly@icloud.com', '+4989592122')
	, ('Sergei', 'Mikhailov', 'Man', '1990-01-01', 'Russia', 'Moscow', 'Ulitsa Arhitektora Schuseva 1', '115432', 'serg_m010190@mail.ru', '+79993456782')
	, ('Ozan', 'Nigde', 'Man', '2001-12-12', 'Türkiye', 'Istanbul', 'İnonu Cd. 83A', '34381', 'ozee12@gmail.com', '+905413416743')
	, ('Makbule', 'Nigde', 'Woman', '2002-02-27', 'Türkiye', 'Istanbul', 'İnonu Cd. 83A', '34381', 'makbule_guzel@gmail.com', '+905534867432')
;
--------------------------------------
-- TABLE 2 
--------------------------------------
create table guides 
(
	guide_id char(50) primary key
	, guide_first_name char(100) not null
	, guide_last_name char(100) not null
	, guide_license_number char(50)
	, guide_date_of_birth date check (guide_date_of_birth <= current_date) not null
	, guide_experience_years integer default 0 check (guide_experience_years >= 0)
);
insert into guides (
	guide_id
	, guide_first_name
	, guide_last_name
	, guide_license_number
	, guide_date_of_birth
	, guide_experience_years
) values 
	('16TR001', 'Mehmet', 'Karaoglu', '1453678956', '1986-04-01', 15)
	, ('10TR402', 'Ali', 'Kupas', '1234580734', '1992-01-10', 10)
	, ('09TR346', 'Haci Ali', 'Onder', '8902343562', '1997-08-13', 7)
	, ('RU7934', 'Nikolay', 'Ivanov', '6754342454', '1988-12-12', 15)	
;

--------------------------------------
-- TABLE 3 
--------------------------------------
create table mountains 
(
	mountain_id serial primary key
	, mountain_name char(100) not null
	, mountain_height_meters integer default 0 check (mountain_height_meters >= 0)
	, mountain_country char(100)
	, mountain_province char(100)
);
insert into mountains (
	mountain_name
	, mountain_height_meters
	, mountain_country
	, mountain_province
) values 
	('Ararat', 5137, 'Türkiye', 'Iğdır')
	, ('Suphan', 4049, 'Türkiye', 'Bitlis')
	, ('Elbrus', 5642, 'Russia', 'Kabardino-Balkaria')
;
--------------------------------------
-- TABLE 4 
--------------------------------------
create table levels 
(
	level_id serial primary key
	, level_name char(50) not null unique
	, level_age_constraint integer default 18 check (level_age_constraint >= 0)
);
insert into levels (
	level_name
	, level_age_constraint
) values 
	('Light', 16)
	, ('Medium', 18)
	, ('Hard', 18)
;
--------------------------------------
-- TABLE 5 
--------------------------------------
create table transport_companies 
(
	transport_company_id serial primary key
	, transport_company_name char(250) not null 
	, country char(100) 
	, representative_full_name char(250)
	, representative_email char(250) not null
	, representative_phone_number char(250) not null
);
insert into transport_companies (
	transport_company_name
	, country
	, representative_full_name
	, representative_email
	, representative_phone_number
) values 
	('İlkbahar', 'Türkiye', 'Ömer Kılıç', 'omer_kilic@ilkbahar.com', '+905416999319')
	, ('Kırmızı Bayrak', 'Türkiye', 'Hakan Aydın', 'aydin.hakan@krmzbyrk.tr', '+905537110101')
	, ('Edelveis', 'Russia', 'Olga Khostova', 'olga_khvostova@edelveis.ru', '+79275435723')
	, ('Maksima Group', 'Russia', 'Maksim Maksimov', 'maksimov.maksim@maksimagr.com', '+78006005510')
;
--------------------------------------
-- TABLE 6 
--------------------------------------
create table accomodation_companies
(
	accomodation_company_id serial primary key
	, accomodation_company_name char(250) not null 
	, accomodation_company_type char(50) check (accomodation_company_type in ('Hotel', 'Hostel'))
	, country char(100) 
	, representative_full_name char(250)
	, representative_email char(250) not null
	, representative_phone_number char(250) not null
);
insert into accomodation_companies (
	accomodation_company_name
	, accomodation_company_type 
	, country
	, representative_full_name
	, representative_email
	, representative_phone_number
) values 
	('Park Inn', 'Hotel',  'Türkiye', 'Necla Calman', 'necla.calman@parkinn.com', '+905417842130')
	, ('Suda Hotels', 'Hostel',  'Türkiye', 'Mohammed Kizilagac', 'mkizilagac@suda.tr', '+905517605624')
	, ('Aqua Light Hotel', 'Hotel',  'Russia', 'Ivan Svetlov', 'ivan_svetlov@aqualight.ru', '+79277093794')
	, ('Hostel Net', 'Hostel',  'Russia', 'Angelina Krasnova', 'mr@hostel.net', '+78806793451')
;
--------------------------------------
-- TABLE 7
--------------------------------------
create table tour_statuses
(
	tour_status_id serial primary key
	, tour_status_name char(100) not null unique
);
insert into tour_statuses (
	tour_status_name
) values ('Wait for Start'), ('In Progress'), ('Completed'), ('Cancelled')
;
--------------------------------------
-- TABLE 8
--------------------------------------
create table routes
(
	route_id char(50) primary key
	, route_name char(250) not null default 'Unspecified'
	, route_level_id integer not null
	, route_mountain_id integer not null
	, route_guide_id char(50) not null default 'Unspecified'
	, constraint fk_route_level_id foreign key (route_level_id) references levels (level_id)
	, constraint fk_route_mountain_id foreign key (route_mountain_id) references mountains (mountain_id)
	, constraint fk_route_guide_id foreign key (route_guide_id) references guides (guide_id)
);
insert into routes (
	route_id
	, route_name
	, route_level_id
	, route_mountain_id
	, route_guide_id
) values 
	('TR00001', 'Beautiful Ararat', 1, 1, '16TR001')
	, ('TR00002', 'Ararat and History', 2, 1, '16TR001')
	, ('TR00003', 'Symbolic Ararat', 3, 1, '10TR402')
	, ('TR00004', 'Meet Suphan', 1, 2, '09TR346')
	, ('TR00005', 'Suphan and its Legends', 2, 2, '09TR346')
	, ('TR00006', 'Unknown Suphan', 3, 2, '10TR402')
	, ('RU00001', 'Get to know Elbrus', 2, 3, 'RU7934')
	, ('RU00002', 'PRO-climbing to Elbrus', 3, 3, 'RU7934')
;
--------------------------------------
-- TABLE 9
--------------------------------------
create table tours
(
	tour_id char(50) primary key
	, route_id char(50) not null
	, price_usd float not null check (price_usd >= 0)
	, planned_start_date date not null -- check (planned_start_date > current_date)
	, planned_end_date date not null check (planned_end_date >= planned_start_date)
	, actual_start_date date --check (actual_start_date <= current_date)
	, actual_end_date date check (actual_end_date >= actual_start_date)
	, tour_status_id integer not null
	, tour_status_comments char(250) 
	, partner_transport_company integer 
	, partner_accomodation_company integer	
	, constraint fk_tours_route_id foreign key (route_id) references routes (route_id)
	, constraint fk_tours_status_id foreign key (tour_status_id) references tour_statuses (tour_status_id)
	, constraint fk_tours_partner_transport_company foreign key (partner_transport_company) references transport_companies (transport_company_id)
	, constraint fk_tours_partner_accomodation_company foreign key (partner_accomodation_company) references accomodation_companies (accomodation_company_id)
);
insert into tours (
	tour_id
	, route_id
	, price_usd
	, planned_start_date
	, planned_end_date
	, actual_start_date
	, actual_end_date
	, tour_status_id
	, tour_status_comments
	, partner_transport_company
	, partner_accomodation_company
) values 
	('TR0000200001', 'TR00002', 220, '2024-03-25', '2024-03-28', null, null, 4, 'The group was not formed', 2, 1)
	, ('TR0000200002', 'TR00002', 240, '2024-04-01', '2024-04-04', '2024-04-08', '2024-04-12', 3, 'Client organisation changed the period of team building', 2, 1)
	, ('TR0000200003', 'TR00002', 240, '2024-04-15', '2024-04-19', '2024-04-15', '2024-04-19', 3, null, 1, 1)
	, ('RU0000100001', 'RU00001', 310, '2024-03-25', '2024-03-28', '2024-03-25', '2024-03-28', 3, null, 4, 4)
	, ('RU0000100002', 'RU00001', 340, '2024-05-01', '2024-05-04', null, null, 1, null, null, null)
;
--------------------------------------
-- TABLE 10
--------------------------------------
create table enrollments
(
	tour_id char(50) not null
	, climber_id int not null
	, enrollment_id char(100) primary key generated always as (tour_id || '_' || climber_id) stored
	, constraint fk_enrollments_tour_id foreign key (tour_id) references tours (tour_id)
	, constraint fk_enrollments_climber_id foreign key (climber_id) references climbers (climber_id)
);
insert into enrollments (
	tour_id
	, climber_id
) values 
	('TR0000200002', 1)
	, ('TR0000200002', 2)
	, ('TR0000200002', 3)
	, ('TR0000200003', 4)
	, ('TR0000200003', 5)
	, ('TR0000200003', 6)
	, ('RU0000100002', 4)
	, ('RU0000100002', 1)
	, ('RU0000100002', 2)
;
--------------------------------------
-- TABLE 11
--------------------------------------
create table climbers_payments
(
	payment_code char(100) not null
	, enrollment_id char(100) not null
	, transaction_id char(250) primary key generated always as (enrollment_id || '#payment' || payment_code) stored
	, transaction_date date not null check (transaction_date <= current_date)
	, amount_usd float not null check (amount_usd > 0)
	, constraint fk_payments_enrollment_id foreign key (enrollment_id) references enrollments (enrollment_id)
);
insert into climbers_payments (
	payment_code
	, enrollment_id
	, transaction_date
	, amount_usd
) values 
	('04ab34c45d3a35', 'TR0000200002_1', '2024-03-25', 240)
	, ('04ab34c45d3a35', 'TR0000200002_2', '2024-03-25', 240)
	, ('04ab34c45d3a35', 'TR0000200002_3', '2024-03-25', 240)
	, ('1ab38c435bd42a', 'RU0000100002_4', '2024-04-16', 170)
	, ('63bad401bd3241', 'RU0000100002_4', '2024-04-18', 170)
	, ('2abg356gcv67fd', 'RU0000100002_1', '2024-04-18', 240)
	, ('26aa7cd00e24df', 'RU0000100002_2', '2024-04-20', 240)
;
--------------------------------------
-- ALTER ALL 11 TABLES AND ADD RECORD_TS FIELD CONTAINING CURRENT_DATE
--------------------------------------
alter table climbers add column record_ts date default current_date; --1
alter table guides add column record_ts date default current_date; --2
alter table mountains add column record_ts date default current_date; --3
alter table levels add column record_ts date default current_date; --4
alter table transport_companies add column record_ts date default current_date; --5
alter table accomodation_companies add column record_ts date default current_date; --6
alter table tour_statuses add column record_ts date default current_date; --7
alter table routes add column record_ts date default current_date; --8
alter table tours add column record_ts date default current_date; --9
alter table enrollments add column record_ts date default current_date; --10
alter table climbers_payments add column record_ts date default current_date; --11