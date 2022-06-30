-- For postgres there's basically no performance difference between text, varchar and char: https://www.postgresql.org/docs/current/datatype-character.html

create schema streaming_service_agregator;

set search_path to streaming_service_agregator,public;

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
	purchase_available		boolean not null default(false),
	purchase_price			decimal(4, 2),
	rent_available			boolean not null default(false),
	rent_price				decimal(4, 2),
	rent_duration			interval,
	included_subscription	boolean,
	
	constraint provides_movie_pk
		primary key	(service, catalogue, movie_name, movie_year),
	
	constraint provides_movie_catalogue_fk
		foreign key (service, catalogue) references catalogue (service, country),
	
	constraint provides_movie_movie_fk
		foreign key (movie_name, movie_year) references movie (name, year),
	
	constraint provides_movie_if_purchaseable_must_have_price
		check(purchase_available = false or purchase_price is not null),

	constraint provides_movie_if_rentable_must_have_price_and_duration
		check(rent_available = false or (rent_price is not null and rent_duration is not null))
);

create table movie_language_audio (
	service		text	not null,
	catalogue	text	not null,
	movie_name	text	not null,
	movie_year	integer	not null,
	language	text	not null,

	constraint movie_language_audio_pk
		primary key	(service, catalogue, movie_name, movie_year, language),

	constraint movie_language_audio_provides_movie_fk
		foreign key	(service, catalogue, movie_name, movie_year) references provides_movie (service, catalogue, movie_name, movie_year)
);

create table movie_language_subtitle (
	service		text	not null,
	catalogue	text	not null,
	movie_name	text	not null,
	movie_year	integer	not null,
	language	text	not null,

	constraint movie_language_subtitle_pk
		primary key	(service, catalogue, movie_name, movie_year, language),

	constraint movie_language_subtitle_provides_movie_fk
		foreign key	(service, catalogue, movie_name, movie_year) references provides_movie (service, catalogue, movie_name, movie_year)
);

create table participates_in_movie (
	movie_name			text	not null,
	movie_year			integer	not null,
	artist_name			text	not null,
	artist_birthday		date	not null,
	participation_type	text	not null,

	constraint participates_in_movie_pk
		primary key (movie_name, movie_year, artist_name, artist_birthday),

	constraint participates_in_movie_movie_fk
		foreign key (movie_name, movie_year) references movie (name, year),

	constraint participates_in_movie_artist_fk
		foreign key (artist_name, artist_birthday) references artist (name, birthday),

	constraint participates_in_movie_allowed_participation_types
		check(participation_type in ('Acting', 'Directing', 'Both'))
);

create table acts_in_movie (
	movie_name		text	not null,
	movie_year		integer	not null,
	artist_name		text	not null,
	artist_birthday	date	not null,
	act_type		text	not null,
	role_type		text	not null,

	constraint acts_in_movie_pk
		primary key (movie_name, movie_year, artist_name, artist_birthday),

	constraint acts_in_movie_participates_in_movie_fk
		foreign key (movie_name, movie_year, artist_name, artist_birthday)
		references participates_in_movie (movie_name, movie_year, artist_name, artist_birthday),

	constraint acts_in_movie_allowed_act_types
		check(act_type in ('Acting', 'Dubbing')),
	
	constraint acts_in_movie_allowed_role_types
		check(role_type in ('Main', 'Supporting'))
);

create table movie_session (
	movie_name			text		not null,
	movie_year			integer		not null,
	"user"				text		not null,
	profile				text		not null,
	start_time			timestamp	not null,
	watched_duration	interval	not null default('0'),
	finished			boolean		not null default(false),
	rating				real,

	constraint movie_session_pk
		primary key (movie_name, movie_year, "user", profile, start_time),

	constraint movie_session_movie_fk
		foreign key (movie_name, movie_year) references movie (name, year),

	constraint movie_session_profile_fk
		foreign key ("user", profile) references profile ("user", name),

	constraint movie_session_rating_should_be_null_or_positive
		check(rating is null or rating >= 0.0)
);

create table tv_show (
	name		text	not null,
	year		integer	not null,
	sinopsis	text,
	rating		real,

	constraint tv_show_pk
		primary key (name, year),
	
	constraint tv_show_rating_should_be_null_or_positive
		check(rating is null or rating >= 0.0)
);

create table season (
	tv_show_name	text	not null,
	tv_show_year	integer	not null,
	number			integer not null,
	year			integer,
	sinopsis		text,
	rating			real,

	constraint season_pk
		primary key (tv_show_name, tv_show_year, number),

	constraint season_tv_show_fk
		foreign key (tv_show_name, tv_show_year) references tv_show (name, year),

	constraint season_rating_should_be_null_or_positive
		check(rating is null or rating >= 0.0)
);

create table provides_season (
	service					text	not null,
	catalogue				text	not null,
	tv_show_name			text	not null,
	tv_show_year			integer	not null,
	season					integer not null,
	season_link				text	not null,
	quality					text,	-- TODO: Maybe we could restrict the values
	purchase_available		boolean not null default(false),
	purchase_price			decimal(4, 2),
	rent_available			boolean not null default(false),
	rent_price				decimal(4, 2),
	rent_duration			interval,
	included_subscription	boolean,
	
	constraint provides_season_pk
		primary key	(service, catalogue, tv_show_name, tv_show_year, season),
	
	constraint provides_season_catalogue_fk
		foreign key (service, catalogue) references catalogue (service, country),
	
	constraint provides_season_season_fk
		foreign key (tv_show_name, tv_show_year, season) references season (tv_show_name, tv_show_year, number),
	
	constraint provides_season_if_purchaseable_must_have_price
		check(purchase_available = false or purchase_price is not null),

	constraint provides_season_if_rentable_must_have_price_and_duration
		check(rent_available = false or (rent_price is not null and rent_duration is not null))
);

create table season_language_audio (
	service			text	not null,
	catalogue		text	not null,
	tv_show_name	text	not null,
	tv_show_year	integer	not null,
	season			integer not null,
	language		text	not null,

	constraint season_language_audio_pk
		primary key	(service, catalogue, tv_show_name, tv_show_year, season, language),

	constraint season_language_audio_provides_season_fk
		foreign key	(service, catalogue, tv_show_name, tv_show_year, season)
		references provides_season (service, catalogue, tv_show_name, tv_show_year, season)
);

create table season_language_subtitle (
	service			text	not null,
	catalogue		text	not null,
	tv_show_name	text	not null,
	tv_show_year	integer	not null,
	season			integer not null,
	language		text	not null,

	constraint season_language_subtitle_pk
		primary key	(service, catalogue, tv_show_name, tv_show_year, season, language),

	constraint season_language_subtitle_provides_season_fk
		foreign key	(service, catalogue, tv_show_name, tv_show_year, season)
		references provides_season (service, catalogue, tv_show_name, tv_show_year, season)
);

create table episode (
	id				uuid	not null,
	tv_show_name	text	not null,
	tv_show_year	integer	not null,
	season			integer not null,
	number			integer not null,

	constraint episode_pk
		primary key (id),

	constraint episode_unique_sk
		unique (tv_show_name, tv_show_year, season, number),
	
	constraint episode_season_fk
		foreign key (tv_show_name, tv_show_year, season)
		references season (tv_show_name, tv_show_year, number)
);

create table participates_in_episode (
	episode				uuid	not null,
	artist_name			text	not null,
	artist_birthday		date	not null,
	participation_type	text	not null,

	constraint participates_in_episode_pk
		primary key (episode, artist_name, artist_birthday),

	constraint participates_in_episode_episode_fk
		foreign key (episode) references episode (id),

	constraint participates_in_episode_artist_fk
		foreign key (artist_name, artist_birthday) references artist (name, birthday),

	constraint participates_in_episode_allowed_participation_types
		check(participation_type in ('Acting', 'Directing', 'Both'))
);

create table acts_in_episode (
	episode			uuid	not null,
	artist_name		text	not null,
	artist_birthday	date	not null,
	act_type		text	not null,
	role_type		text	not null,

	constraint acts_in_episode_pk
		primary key (episode, artist_name, artist_birthday),

	constraint acts_in_episode_participates_in_episode_fk
		foreign key (episode, artist_name, artist_birthday)
		references participates_in_episode (episode, artist_name, artist_birthday),

	constraint acts_in_episode_allowed_act_types
		check(act_type in ('Acting', 'Dubbing')),
	
	constraint acts_in_episode_allowed_role_types
		check(role_type in ('Main', 'Supporting'))
);

create table episode_session (
	episode				uuid	not null,
	"user"				text		not null,
	profile				text		not null,
	start_time			timestamp	not null,
	watched_duration	interval	not null default('0'),
	finished			boolean		not null default(false),
	rating				real,

	constraint episode_session_pk
		primary key (episode, "user", profile, start_time),

	constraint episode_session_episode_fk
		foreign key (episode) references episode (id),

	constraint episode_session_profile_fk
		foreign key ("user", profile) references profile ("user", name),

	constraint episode_session_rating_should_be_null_or_positive
		check(rating is null or rating >= 0.0)
);
