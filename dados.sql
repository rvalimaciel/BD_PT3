set search_path to streaming_service_agregator, public;

insert into admin_account
values ('root', 'todo-use-real-hash');

insert into user_account
values ('dmdemoura', 'todo-use-real-hash');

insert into profile
values ('dmdemoura', 'Amanda');

insert into streaming_service
values ('netflix', 10, 'root');

insert into subscribe
values ('dmdemoura', 'netflix');

insert into catalogue
values ('netflix', 'brasil');

insert into artist
values ('brad pitt', '1963-12-18', 'ator muito famosão');

insert into movie
values ('Tróia', 2004, 'O filme conta a história da batalha entre os reinos antigos de Troia e Esparta. Durante uma visita ao rei de Esparta, Menelau, o príncipe troiano Paris se apaixona pela esposa do rei, Helena, e a leva de volta para Troia. O irmão de Menelau, o rei Agamenon, que já havia derrotado todos os exércitos na Grécia, encontra o pretexto que faltava para declarar guerra contra Troia, o único reino que o impede de controlar o Mar Egeu.');

insert into provides_movie
values ('netflix', 'brasil', 'Tróia', 2004, 'www.netflix.com/troia-filme-online-free', '1080p', false, null, false, null, null, true);

insert into movie_language_audio
values ('netflix', 'brasil', 'Tróia', 2004, 'pt-Br');

insert into movie_language_subtitle
values ('netflix', 'brasil', 'Tróia', 2004, 'pt-Br');

insert into participates_in_movie
values ('Tróia', 2004, 'brad pitt', '1963-12-18', 'Acting');

insert into acts_in_movie
values ('Tróia', 2004, 'brad pitt', '1963-12-18', 'Acting', 'Main');

insert into movie_session
values ('Tróia', 2004, 'dmdemoura', 'Amanda', '2022-01-08 04:05:06', '10 minutes', false, null);

insert into tv_show
values ('Friends', 1994, 'Seis amigos, três homens e três mulheres, enfrentam a vida e os amores em Nova York e adoram passar o tempo livre na cafeteria Central Perk.', null);

insert into season
values ('Friends', 1994, 1, 1994, 'Seis amigos, três homens e três mulheres, enfrentam a vida e os amores em Nova York e adoram passar o tempo livre na cafeteria Central Perk.', null);

insert into provides_season
values ('netflix', 'brasil', 'Friends', 1994, 1, 'www.netflix.com/friends-season-one', '1080p', false, null, false, null, null, true);

insert into season_language_audio
values ('netflix', 'brasil', 'Friends', 1994, 1, 'en-Us');

insert into season_language_subtitle
values ('netflix', 'brasil', 'Friends', 1994, 1, 'pt-Br');

insert into episode
values ('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'Friends', 1994, 1, 1);

insert into participates_in_episode
values ('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'brad pitt', '1963-12-18', 'Acting');

insert into acts_in_episode
values ('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'brad pitt', '1963-12-18', 'Acting', 'Supporting');

insert into episode_session
values ('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'dmdemoura', 'Amanda', '2022-01-08 04:05:06', '10 minutes', false, null);
