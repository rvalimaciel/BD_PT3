set search_path to streaming_service_agregator, public;


insert into admin_account
values
	('root', 'todo-use-real-hash'),
	('valdisnei', 'todo-use-real-hash'),
	('service-account', 'soinawircmiew');

insert into user_account
values  ('dmdemoura', 'todo-use-real-hash'),
		('rvalim', 'aoicwmiewmcoi');

insert into profile
values
	('dmdemoura', 'Amanda'),
	('dmdemoura', 'Mãe'),
	('dmdemoura', 'Pai');

insert into streaming_service
values
	('Netflix', 25.90, 'root'),
	('Disney+', 27.90, 'valdisnei');

insert into subscribe
values
	('dmdemoura', 'Netflix'),
	('dmdemoura', 'Disney+');

insert into catalogue
values
	('Netflix', 'USA'),
	('Netflix', 'brasil'),
	('Disney+', 'USA'),
	('Disney+', 'brasil');

insert into artist
values
	('brad pitt', '1963-12-18', 'ator muito famosão'),

	('Dee Bradley Baker', '1962-08-31',
		'Dee Bradley Baker is an American voice actor from Indiana. He first became known for voicing Olmec in Legends of the Hidden Temple before voicing Daffy Duck in Space Jam. He is well-known for voicing Klaus in American Dad, the Clone Troopers in several Star Wars media, Ra''s al Ghul in Batman: Arkham City, Momo and Appa in Avatar: The Last Airbender, Perry the Platypus in Phineas & Ferb, Sunny Jim in Lobo, Kevin the Sea Cucumber in SpongeBob SquarePants, Numbuh Four in Codename: Kids Next Door and Gravemind in Halo 2.

- IMDb Mini Biography By: Christian Frates'),

	('Ashley Eckstein', '1981-09-22',
		'Ashley was born in Louisville, Kentucky but was raised in Orlando, Florida. Often playing the antagonist, Ashley played Muffy, the popular nemesis on That''s So Raven. Besides acting, Ashley loves to design and make clothes. Ashley''s parents are Tony and Sharon Drane. She also has three siblings, Michael, Tara and Taylor.

- IMDb Mini Biography By: Anonymous'),

	('Hayden Christensen', '1981-04-19',
		'Hayden Christensen was born April 19, 1981 in Vancouver, British Columbia, Canada. His parents, Alie and David Christensen, are in the communications business. He is of Danish (father) and Swedish and Italian (mother) descent. Hayden grew up in Markham, Ontario, with siblings Kaylen, Hejsa, and Tove. Hayden set out to become an actor when a chance encounter at the age of eight placed him in his first commercial, for Pringles. When he was thirteen, he had starring roles in several dramatic television series.'),
	('brad pitts', '2000-12-18', 'ator pouco famoso');

insert into movie
values
	('Tróia', 2004, 'O filme conta a história da batalha entre os reinos antigos de Troia e Esparta. Durante uma visita ao rei de Esparta, Menelau, o príncipe troiano Paris se apaixona pela esposa do rei, Helena, e a leva de volta para Troia. O irmão de Menelau, o rei Agamenon, que já havia derrotado todos os exércitos na Grécia, encontra o pretexto que faltava para declarar guerra contra Troia, o único reino que o impede de controlar o Mar Egeu.',
		7.0),

	('Star Wars: Episode II - Attack of the Clones', 2002,
		'todo',
		4.0),

	('Star Wars: Episode III - Revenge of the Sith', 2005,
		'Three years into the Clone Wars, the Jedi rescue Palpatine from Count Dooku. As Obi-Wan pursues a new threat, Anakin acts as a double agent between the Jedi Council and Palpatine and is lured into a sinister plan to rule the galaxy.',
		8.0),

	('Star Wars: The Clone Wars', 2008,
		'Set between Episode II and III, The Clone Wars is the first computer animated Star Wars film. Anakin and Obi Wan must find out who kidnapped Jabba the Hutt''s son and return him safely. The Seperatists will try anything to stop them and ruin any chance of a diplomatic agreement between the Hutts and the Republic.',
		5.0),
	('A Vida de Brian', 1979, 'Brian Cohen é um judeu como outro qualquer, mas, em uma série de eventos ridículos, foi confundido com o Messias desde que nasceu, e, desde então, mantém essa fama e se torna lider de um movimento religioso. Um dia, ele é levado até Pôncio Pilatos e condenado à crucificação.');

insert into provides_movie
values  ('Netflix', 'brasil', 'Tróia', 2004, 'www.netflix.com/troia-filme-online-free', '1080p', false, null, false, null, null, true),
	('Disney+', 'brasil', 'Star Wars: Episode III - Revenge of the Sith', 2005,
		'www.disneyplus.com/stream/rots', '1080p',
		false, null, false, null, null, true),
	('Disney+', 'brasil', 'Star Wars: The Clone Wars', 2008,
		'www.disneyplus.com/stream/tcw-movie', '540p',
		false, null, false, null, null, true),
	('Netflix', 'UK', 'A Vida de Brian', 1979, 'www.netflix.com/a-vida-de-brian-filme-online-free', '1080p', false, null, false, null, null, true);

insert into movie_language_audio
values  ('Netflix', 'brasil', 'Tróia', 2004, 'pt-Br'),
		('Netflix', 'brasil', 'Tróia', 2004, 'en-Us');

insert into movie_language_subtitle
values  ('Netflix', 'brasil', 'Tróia', 2004, 'pt-Br'),
		('Netflix', 'brasil', 'Tróia', 2004, 'en-Us');

insert into participates_in_movie
values
	('Tróia', 2004, 'brad pitt', '1963-12-18', 'Acting'),
	('Star Wars: Episode II - Attack of the Clones', 2002, 'Hayden Christensen', '1981-04-19',
		'Acting'),
	('Star Wars: Episode III - Revenge of the Sith', 2005, 'Hayden Christensen', '1981-04-19',
		'Acting'),
	('Star Wars: The Clone Wars', 2008, 'Dee Bradley Baker', '1962-08-31', 'Acting'),
	('Tróia', 2004, 'brad pitts', '2000-12-18', 'Acting');

insert into acts_in_movie
values
	('Tróia', 2004, 'brad pitt', '1963-12-18', 'Acting', 'Main'),
	('Tróia', 2004, 'brad pitts', '2000-12-18', 'Acting', 'Supporting'),
	('Star Wars: Episode II - Attack of the Clones', 2002, 'Hayden Christensen', '1981-04-19',
		'Anakin Skywalker', 'Acting', 'Main'),
	('Star Wars: Episode III - Revenge of the Sith', 2005, 'Hayden Christensen', '1981-04-19',
		'Anakin Skywalker', 'Acting', 'Main'),
	('Star Wars: The Clone Wars', 2008, 'Dee Bradley Baker', '1962-08-31',
		'Captain Rex', 'Dubbing', 'Main'),
	('Star Wars: The Clone Wars', 2008, 'Dee Bradley Baker', '1962-08-31',
		'Commander Cody', 'Dubbing', 'Main'),
	('Star Wars: The Clone Wars', 2008, 'Dee Bradley Baker', '1962-08-31',
		'Commander Fox', 'Dubbing', 'Supporting');

insert into movie_session
values  ('Tróia', 2004, 'dmdemoura', 'Amanda', '2022-01-01 16:01:14', '2 hours', true, 8.0),
		('Tróia', 2004, 'dmdemoura', 'Amanda', '2022-05-03 16:01:14', '15 minutes', true, 8.0),
		('Tróia', 2004, 'dmdemoura', 'Amanda', '2022-01-08 04:05:06', '10 minutes', false, null),
		('Tróia', 2004, 'dmdemoura', 'Pai', '2004-05-11 13:00:00', '2 hours', true, 10.0),
		('Tróia', 2004, 'dmdemoura', 'Pai', '2022-02-13 18:05:26', '1 hours', true, 9.0),
		('Tróia', 2004, 'dmdemoura', 'Mãe', '2022-02-13 18:05:26', '2 hours', true, 5.0);

insert into tv_show
values
	('Friends', 1994,
		'Seis amigos, três homens e três mulheres, enfrentam a vida e os amores em Nova York e adoram passar o tempo livre na cafeteria Central Perk.',
		8.0),
	('Star Wars: The Clone Wars', 2008,
		'As The Clone Wars sweep through the galaxy, the heroic Jedi Knights struggle to maintain order and restore peace. More and more systems are falling prey to the forces of the Dark Side as the Galactic Republic slips further and further under the sway of the Separatists and their never-ending droid army.',
		9.5);

insert into season
values
	('Friends', 1994, 1, 1994,
		'Seis amigos, três homens e três mulheres, enfrentam a vida e os amores em Nova York e adoram passar o tempo livre na cafeteria Central Perk.',
		null),
	('Star Wars: The Clone Wars', 2008, 1, 2008,
		'Season one focuses on various battles fought between the Republic and the Separatists, and their efforts to convince more planets and races to join them. The main antagonists are Count Dooku, his informal apprentice Asajj Ventress, and the cyborg commander of the Separatists'' droid armies, General Grievous. There are also several episodes that do not focus on the conflict with the Separatists, but rather other aspects of the Clone Wars.',
		null);

insert into provides_season
values
	('Netflix', 'brasil', 'Friends', 1994, 1, 'www.netflix.com/friends-season-one', '1080p',
		false, null, false, null, null, true),
	('Disney+', 'brasil', 'Star Wars: The Clone Wars', 2008, 1,
		'www.disneyplus.com/stream/tcw/1', '540p', false, null, false, null, null, true);


insert into season_language_audio
values  ('Netflix', 'brasil', 'Friends', 1994, 1, 'en-Us'),
		('Netflix', 'brasil', 'Friends', 1994, 1, 'pt-Br');

insert into season_language_subtitle
values  ('Netflix', 'brasil', 'Friends', 1994, 1, 'pt-Br'),
		('Netflix', 'brasil', 'Friends', 1994, 1, 'en-Us');

insert into episode
values
	('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'Friends', 1994, 1, 1),
	('541529ee-9a73-43b2-b324-5221bbb8413f', 'Friends', 1994, 1 , 2),
	('57427300-e544-4ba6-ba58-045f1f8e2c4b', 'Friends', 1994, 1 , 3),
	('ac3c6603-1692-464f-85c4-c2d802442e5a', 'Friends', 1994, 1 , 4),
	('902a612b-b1da-472e-a04f-e7b6f609ff52', 'Friends', 1994, 1 , 5),
	('590e8198-1622-43a2-9a8a-668a520c6710', 'Friends', 1994, 1 , 6),
	('69eb7f0f-766c-4f21-8c78-6320aa0a78f6', 'Friends', 1994, 1 , 7),
	('b732bb59-9426-4a50-b3c9-070dd4e4d50a', 'Friends', 1994, 1 , 8),
	('4eded364-b176-402a-bc83-1e1e778045ad', 'Friends', 1994, 1 , 9),
	('c8791f03-8a96-4512-b439-8bc227e0f53c', 'Friends', 1994, 1 , 10),
	('1a810d80-d1c4-488a-a7d8-1476db0ef9dc', 'Friends', 1994, 1 , 11),
	('f40fd081-95e4-4e6c-b5f7-8a405534b76e', 'Friends', 1994, 1 , 12),
	('39eb1db9-ffc6-4f57-8c24-3675577ead1e', 'Friends', 1994, 1 , 13),
	('6e9d386b-d73a-4981-beaf-e460971b952f', 'Friends', 1994, 1 , 14),
	('3240ecdd-4bd6-4596-a69b-07429e9d6230', 'Friends', 1994, 1 , 15),
	('5cbf4877-cb0a-446f-949a-d4976cd6d7df', 'Friends', 1994, 1 , 16),
	('a8b3cb5f-f422-4750-8b10-de6201d5d21d', 'Friends', 1994, 1 , 17),
	('9c9d0c0a-ddf7-4c4f-81e6-3e3b69456b2e', 'Friends', 1994, 1 , 18),
	('083bb2bc-21d7-4ed6-ae48-65b0cce94523', 'Friends', 1994, 1 , 19),
	('141e1450-08f2-4efd-a6c2-546d8d7ea0c6', 'Friends', 1994, 1 , 20),
	('58e9b56b-f0f7-4c91-a823-55922ad234bb', 'Friends', 1994, 1 , 21),
	('55c9d36e-8ac7-4fba-88a7-1c6ab75b954f', 'Friends', 1994, 1 , 22),
	('b203e90f-3d70-4bce-94da-6c8db9422f64', 'Friends', 1994, 1 , 23),
	('8492c716-2297-4b81-aea7-919460362bcd', 'Friends', 1994, 1 , 24),
	('9619b3c5-3b8e-423a-a7aa-43219fbeef1c', 'Star Wars: The Clone Wars', 2008, 1, 1),
	('b1a028bd-b69c-41ca-926c-58f4212585f7', 'Star Wars: The Clone Wars', 2008, 1, 2),
	('b5314a7d-5577-482b-a15a-cc35add3c6b0', 'Star Wars: The Clone Wars', 2008, 1, 3),
	('20498673-f748-4d22-9104-62ffa48041c1', 'Star Wars: The Clone Wars', 2008, 1, 4),
	('d00c26f7-8a6e-4c1b-860c-5ba7b76d3f63', 'Star Wars: The Clone Wars', 2008, 1, 5),
	('5f2e630e-2c1a-4b77-ad25-9f05257bfe9e', 'Star Wars: The Clone Wars', 2008, 1, 6),
	('db9c74ed-2ab9-4912-83a9-29be3b99260d', 'Star Wars: The Clone Wars', 2008, 1, 7),
	('c68c398d-f50f-4e2b-93b5-52f347d51a0d', 'Star Wars: The Clone Wars', 2008, 1, 8),
	('c07f253c-8741-4edd-9142-a14f9a1e401d', 'Star Wars: The Clone Wars', 2008, 1, 9),
	('7efde112-0474-4c9e-831d-bc2bacf250a7', 'Star Wars: The Clone Wars', 2008, 1, 10),
	('06f20e05-1aa2-4e40-a440-65c4052e0a1c', 'Star Wars: The Clone Wars', 2008, 1, 11),
	('1c8509ce-9a65-4921-8f77-54179cb8f734', 'Star Wars: The Clone Wars', 2008, 1, 12),
	('ee841c04-0030-44c5-823d-bbaacb8f1e92', 'Star Wars: The Clone Wars', 2008, 1, 13),
	('4ca49764-26ce-41db-bcbb-a8d4e742d6d4', 'Star Wars: The Clone Wars', 2008, 1, 14),
	('7e75c36b-3db8-4426-b164-e2d2adaea28b', 'Star Wars: The Clone Wars', 2008, 1, 15),
	('b226deb2-a3eb-422b-8a1c-ab8eff6f9c61', 'Star Wars: The Clone Wars', 2008, 1, 16),
	('1159bd66-254a-4b6a-bca7-58eec0bef168', 'Star Wars: The Clone Wars', 2008, 1, 17),
	('3d35a931-cad1-49ac-9fdb-4c3f47cb534e', 'Star Wars: The Clone Wars', 2008, 1, 18),
	('4ed932fe-63c3-4785-84d2-b24bb3373c45', 'Star Wars: The Clone Wars', 2008, 1, 19),
	('a1ed9a75-0f11-4cf6-ad81-27bcc26e15cd', 'Star Wars: The Clone Wars', 2008, 1, 20),
	('e6d50b34-5276-4577-9e66-16083ab63eb8', 'Star Wars: The Clone Wars', 2008, 1, 21),
	('e575d20f-ccd8-4f28-b8e4-9761a9c3dc59', 'Star Wars: The Clone Wars', 2008, 1, 22);

insert into participates_in_episode
values
	('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'brad pitt', '1963-12-18', 'Acting'),
	('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'brad pitts', '2000-12-18', 'Acting'),
	-- Friends S01E01
	('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'brad pitt', '1963-12-18', 'Acting'),
	-- SWTCW S01E01
	('9619b3c5-3b8e-423a-a7aa-43219fbeef1c', 'Dee Bradley Baker', '1962-08-31', 'Acting'),
	-- SWTCW S01E02
	('b1a028bd-b69c-41ca-926c-58f4212585f7', 'Ashley Eckstein', '1981-09-22', 'Acting'),
	('b1a028bd-b69c-41ca-926c-58f4212585f7', 'Dee Bradley Baker', '1962-08-31', 'Acting');



insert into acts_in_episode
values
	('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'brad pitt', '1963-12-18', 'Acting', 'Supporting'),
	('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'brad pitts', '2000-12-18', 'Acting', 'Supporting'),
	-- Friends S01E01
	('4b504e51-944c-4fcc-897b-f76ec0ecb66e',
		'brad pitt', '1963-12-18', 'Will Colbert', 'Acting', 'Supporting'),

	-- SWTCW S01E01
	('9619b3c5-3b8e-423a-a7aa-43219fbeef1c',
		'Dee Bradley Baker', '1962-08-31', 'Commander Thire', 'Dubbing', 'Main'),

	('9619b3c5-3b8e-423a-a7aa-43219fbeef1c',
		'Dee Bradley Baker', '1962-08-31', 'Jek', 'Dubbing', 'Supporting'),

	('9619b3c5-3b8e-423a-a7aa-43219fbeef1c',
		'Dee Bradley Baker', '1962-08-31', 'Rys', 'Dubbing', 'Supporting'),

	('9619b3c5-3b8e-423a-a7aa-43219fbeef1c',
		'Dee Bradley Baker', '1962-08-31', 'Zak', 'Dubbing', 'Supporting'),

	-- SWTCW S01E02
	('b1a028bd-b69c-41ca-926c-58f4212585f7',
		'Ashley Eckstein', '1981-09-22', 'Ahsoka Tano', 'Dubbing', 'Main'),

	('b1a028bd-b69c-41ca-926c-58f4212585f7',
		'Dee Bradley Baker', '1962-08-31', 'Commander Wolffe', 'Dubbing', 'Main'),

	('b1a028bd-b69c-41ca-926c-58f4212585f7',
		'Dee Bradley Baker', '1962-08-31', 'Commander Cody', 'Dubbing', 'Supporting'),

	('b1a028bd-b69c-41ca-926c-58f4212585f7',
		'Dee Bradley Baker', '1962-08-31', 'Captain Rex', 'Dubbing', 'Supporting');


insert into episode_session
values 
	('4b504e51-944c-4fcc-897b-f76ec0ecb66e', 'dmdemoura', 'Amanda', '2022-01-08 04:05:06',
		'22 minutes', true, null),
	('541529ee-9a73-43b2-b324-5221bbb8413f', 'dmdemoura', 'Amanda', '2022-01-08 04:27:06',
		'22 minutes', true, null),
	('57427300-e544-4ba6-ba58-045f1f8e2c4b', 'dmdemoura', 'Amanda', '2022-01-08 04:49:06',
		'10 minutes', false, null),
	('9619b3c5-3b8e-423a-a7aa-43219fbeef1c', 'dmdemoura', 'Amanda', '2010-04-10 08:00:00',
		'25 minutes', true, null),
	('b1a028bd-b69c-41ca-926c-58f4212585f7', 'dmdemoura', 'Amanda', '2010-04-10 08:25:00',
		'25 minutes', true, null),
	('b5314a7d-5577-482b-a15a-cc35add3c6b0', 'dmdemoura', 'Amanda', '2010-04-10 08:50:00',
		'25 minutes', true, null),
	('20498673-f748-4d22-9104-62ffa48041c1', 'dmdemoura', 'Amanda', '2010-04-10 09:15:00',
		'25 minutes', true, null),
	('d00c26f7-8a6e-4c1b-860c-5ba7b76d3f63', 'dmdemoura', 'Amanda', '2010-04-10 09:40:00',
		'25 minutes', true, null),
	('5f2e630e-2c1a-4b77-ad25-9f05257bfe9e', 'dmdemoura', 'Amanda', '2010-04-10 09:55:00',
		'25 minutes', true, null),
	('db9c74ed-2ab9-4912-83a9-29be3b99260d', 'dmdemoura', 'Amanda', '2010-04-10 10:20:00',
		'25 minutes', true, null),
	('c68c398d-f50f-4e2b-93b5-52f347d51a0d', 'dmdemoura', 'Amanda', '2010-04-10 10:45:00',
		'25 minutes', true, null),
	('c07f253c-8741-4edd-9142-a14f9a1e401d', 'dmdemoura', 'Amanda', '2010-04-10 11:10:00',
		'25 minutes', true, null);
