-- For postgres there's basically no performance difference between text, varchar and char: https://www.postgresql.org/docs/current/datatype-character.html

create table user_account (
	username		text	not null,
	password_hash	text	not null,

	constraint user_account_pk
		primary key (username)
);

create table admin_account (
	username		text	not null,
	password_hash	text	not null,

	constraint admin_account_pk
		primary key (username)
);

create table streaming_service (
	name				text			not null, 
	subscription_price	decimal(4,2)	not null,
	administrator		text,
	
	constraint streaming_service_pk 
		primary key (name),
	
	constraint streaming_service_admin_fk
		foreign key (administrator) references admin_account (username)
);

create table subscribe (
	"user"	text	not null,
	service	text	not null,

	constraint subscribe_pk
		primary key ("user", service),
	
	constraint subscribe_user_fk
		foreign key ("user") references user_account (username),

	constraint subscribe_service_fk
		foreign key (service) references streaming_service (name)
);

create table catalogue (
	service	text	not null,
	country	text	not null,

	constraint catalogue_pk
		primary key (service, country),
	
	constraint catalogue_service_fk
		foreign key (service) references streaming_service (name)
);

create table profile (
	"user"	text	not null,
	name	text	not null,

	constraint profile_pk
		primary key ("user", name),
	
	constraint profile_user_fk
		foreign key ("user") references user_account (username)
);

create table artist (
	name			text	not null,
	birthday		date	not null,
	profile_text	text,

	constraint artist_pk
		primary key (name, birthday),
	
	constraint artist_birthday_must_be_in_past
		check(birthday < current_date)
);

create table movie (
	name		text	not null,
	year		integer	not null,
	sinopsis	text,
	rating		real,

	constraint movie_pk
		primary key (name, year),
	
	constraint movie_rating_should_be_null_or_positive
		check(rating is null or rating >= 0.0)
);

create table provides_movie (
	service					text	not null,
	catalogue				text	not null,
	movie_name				text	not null,
	movie_year				integer	not null,
	movie_link				text	not null,
	quality					text,	-- TODO: Maybe we could restrict the values
	purchase_available		boolean,
	purchase_price			decimal(4, 2),
	rent_available			boolean,
	rent_price				decimal(4, 2),
	rent_duration			interval,
	included_subscription	boolean,
	
	constraint provides_movie_pk
		primary key	(service, catalogue, movie_name, movie_year),
	
	constraint provides_movie_catalogue_fk
		foreign key (service, catalogue) references catalogue (service, country),
	
	constraint provides_movie_movie_fk
		foreign
);
