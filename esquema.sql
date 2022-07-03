-- Para dados do tipo string, foi usado o tipo do PostgreSQL "text".
-- Esse tipo foi escolhido pois no PostgreSQL não há diferença de performance
-- significante entre "char(n)", "varchar(n)" e "text", segundo a própria
-- documentação do PostgreSQL: https://www.postgresql.org/docs/current/datatype-character.html
-- 
-- Assim, para campos que não tem um limite de tamanho semântico, optamos por utilizar 
-- text, para não definir um limite arbitrário que poderia causar problemas no futuro.

-- Para decimais representando preços foi escolhido, usar precisão de 8 digitos, 
-- com uma escala de 2. Assim temos 6 digitos totais para a parte inteira do preço, e
-- 2 digitos para os centavos.

-- Cria um schema para a aplicação, e adiciona no search_path para evitar repetição
-- nesse script:
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
	subscription_price	decimal(8,2)	not null,
	administrator		text,
	
	constraint streaming_service_pk 
		primary key (name),
	
	constraint streaming_service_admin_fk
		foreign key (administrator) references admin_account (username)
		-- Se o nome de usuário do admin mudar, podemos atualizar as referências também.
		on update cascade 
		-- Se o admin for deletado, como o campo é opcional, podemos definir como nulo.
		on delete set null
);

create table subscribe (
	"user"	text	not null,
	service	text	not null,

	constraint subscribe_pk
		primary key ("user", service),
	
	constraint subscribe_user_fk
		foreign key ("user") references user_account (username)
		-- Se o nome do usuário mudar, podemos atualizar as referências também.
		on update cascade 
		-- Se o usuário for deletado não faz sentido manter suas assinaturas.
		on delete cascade,

	constraint subscribe_service_fk
		foreign key (service) references streaming_service (name)
		-- Se o nome do serviço mudar, podemos atualizar as referências também.
		on update cascade 
		-- Não deveria ser possível deletar um serviço no qual os usuários ainda
		-- tem assinaturas em.
		on delete restrict
);

create table catalogue (
	service	text	not null,
	country	text	not null,

	constraint catalogue_pk
		primary key (service, country),
	
	constraint catalogue_service_fk
		foreign key (service) references streaming_service (name)
		-- Se o nome do serviço mudar, podemos atualizar as referências também.
		on update cascade 
		-- Se o serviço for deletado não faz sentido manter seu catálogo.
		on delete cascade
);

create table profile (
	"user"	text	not null,
	name	text	not null,

	constraint profile_pk
		primary key ("user", name),
	
	constraint profile_user_fk
		foreign key ("user") references user_account (username)
		-- Se o nome do usuário mudar, podemos atualizar as referências também.
		on update cascade 
		-- Se o usuário for deletado não faz sentido manter seus perfis.
		on delete cascade
);

create table artist (
	name			text	not null,
	birthday		date	not null,
	profile_text	text,

	constraint artist_pk
		primary key (name, birthday),
	
	-- Como se trata de uma data de nascimento, uma checagem fácil de se fazer é
	-- verificar se está no passado. Não é verificado uma distância específica,
	-- por que seria díficil determinar qual seria um valor adequado. Por exemplo
	-- se um ator mirim participar da filmagem de um filme, e tivessemos definido
	-- arbitrariamente que a data de nascimento deveria estar 18 anos no passado,
	-- não seria possível corretamente inserir esse dado.
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
	
	
	-- A nota do filme pode não estar presente se o filme ainda não foi avaliado,
	-- ou então deve ser uma nota entre 0 e 10, para que exista um limite no qual
	-- os usuários possam avaliar o filme.
	constraint movie_rating_should_be_null_or_between_zero_and_ten
		check(rating is null or rating between 0.0 and 10.0)
);

create table provides_movie (
	service					text	not null,
	catalogue				text	not null,
	movie_name				text	not null,
	movie_year				integer	not null,
	movie_link				text	not null,
	quality					text,
	purchase_available		boolean not null default(false),
	purchase_price			decimal(8, 2),
	rent_available			boolean not null default(false),
	rent_price				decimal(8, 2),
	rent_duration			interval,
	included_subscription	boolean,
	
	constraint provides_movie_pk
		primary key	(service, catalogue, movie_name, movie_year),
	
	constraint provides_movie_catalogue_fk
		foreign key (service, catalogue) references catalogue (service, country)
		-- Se o nome do serviço ou catálogo for alterado basta propagar a atualzação.
		on update cascade
		-- Se o catálogo for deletado, não faz mais sentido que ele disponibilize filmes.
		on delete cascade,
	
	constraint provides_movie_movie_fk
		foreign key (movie_name, movie_year) references movie (name, year)
		-- Se o nome do filme ou ano forem alterados basta propagar a atualização.
		on update cascade
		-- Se um filme ainda é disponiblizado por algum serviço de streaming, não faz
		-- sentido permitir que o filme seja deletado, afinal o próposito da aplicação
		-- é registrar todos filmes e séries disponíveis em um conjunto de serviços
		-- de streaming.
		on delete restrict,
	
	-- Se um filme pode ser comprado, ele precisa ter um preço registrado. Caso contrário
	-- o preço é um campo desconsiderado tanto se for nulo ou presente.
	constraint provides_movie_if_purchaseable_must_have_price
		check(purchase_available = false or purchase_price is not null),

	-- Se um filme pode ser aluguel, ele precisa ter preço e duração de aluguel registrados.
	-- Caso contrário ambos campos são desconsiderados tanto se forem nulos ou presentes.
	constraint provides_movie_if_rentable_must_have_price_and_duration
		check(rent_available = false or (rent_price is not null and rent_duration is not null))

	-- É completamente possível que um filme possa estar disponível para compra e/ou aluguel,
	-- ao mesmo tempo que é incluso com a assinatura. Já que alguem que não tem a assinatura
	-- pode prefirir comprar/ou alugar, em vez de assinar o serviço inteiro.
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
		foreign key	(service, catalogue, movie_name, movie_year)
		references provides_movie (service, catalogue, movie_name, movie_year)
		-- Se o nome do filme ou ano forem alterados basta propagar a atualização.
		on update cascade
		-- Se o filme não for mais disponibilizado em um catálogo,
		-- deve se remover as informações de idioma associadas.
		on delete cascade
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
		foreign key	(service, catalogue, movie_name, movie_year)
		references provides_movie (service, catalogue, movie_name, movie_year)
		-- Se o nome do filme ou ano forem alterados basta propagar a atualização.
		on update cascade
		-- Se o filme não for mais disponibilizado em um catálogo,
		-- deve se remover as informações de idioma associadas.
		on delete cascade
);

create table participates_in_movie (
	movie_name			text	not null,
	movie_year			integer	not null,
	artist_name			text	not null,
	artist_birthday		date	not null,
	participation_type	text	not null,

	constraint participates_in_movie_pk
		primary key (movie_name, movie_year, artist_name, artist_birthday),
	
	-- Justificativa sobre as as operações "on delete":
	--
	-- Filmes e Artistas são ambas entidades fortes, mas entre elas o foco do sistema é prover
	-- informações sobre o Filme, e a entidade Artista só existe para armazenar metadados
	-- sobre Filmes e Séries.
	-- Dessa forma, deve se saber todos Artistas que participam nos Filmes cadastrados,
	-- mas não é necessário saber todos Filmes dos quais um Artista participou.

	constraint participates_in_movie_movie_fk
		foreign key (movie_name, movie_year) references movie (name, year)
		-- Se o nome do filme ou ano forem alterados basta propagar a atualização.
		on update cascade
		-- Se o filme for removido, as informações de participação devem ser removidas.
		on delete cascade,

	constraint participates_in_movie_artist_fk
		foreign key (artist_name, artist_birthday) references artist (name, birthday)
		-- Se o nome ou data de nascimento do artista forem alterados basta propagar a
		-- atualização.
		on update cascade
		-- Não deve ser permitido remover um artista que ainda participa de um filme.
		on delete restrict,

	-- Checa que o tipo de participação é um dos valores permitidos. Os nomes devem ser
	-- exatamente iguais, por que é responsabilidade da aplicação utilizar os nomes corretos
	-- sem inconsistências de letras maíusculas ou mininusculas, e isso também simplifica
	-- a aplicação que não precisa aceitar todas variações possiveis também.
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
		references participates_in_movie (movie_name, movie_year, artist_name, artist_birthday)
		-- Se ocorrer alguma alteração no nome/ano do filme ou nome/data de nascimento
		-- do artista podemos só atualizar a referência.
		on update cascade
		-- Se a participação for removida, a atuação tambem deve ser.
		on delete cascade,

	-- Checa que o tipo de atuação é um dos valores permitidos. Os nomes devem ser
	-- exatamente iguais, por que é responsabilidade da aplicação utilizar os nomes corretos
	-- sem inconsistências de letras maíusculas ou mininusculas, e isso também simplifica
	-- a aplicação que não precisa aceitar todas variações possiveis também.
	constraint acts_in_movie_allowed_act_types
		check(act_type in ('Acting', 'Dubbing')),
	
	-- Checa que o tipo de atuação é um dos valores permitidos. Os nomes devem ser
	-- exatamente iguais, por que é responsabilidade da aplicação utilizar os nomes corretos
	-- sem inconsistências de letras maíusculas ou mininusculas, e isso também simplifica
	-- a aplicação que não precisa aceitar todas variações possiveis também.
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
		foreign key (movie_name, movie_year) references movie (name, year)
		-- Se o nome do filme ou ano forem alterados basta propagar a atualização.
		on update cascade
		-- Se o filme for deletado, podemos também remover todas as sessões e avaliações.
		on delete cascade,

	constraint movie_session_profile_fk
		foreign key ("user", profile) references profile ("user", name)
		-- Se o nome de usuário ou perfil forem alterados basta propagar a atualização.
		on update cascade
		-- Se o usuário for deletado, o histórico de visualizações também é removido.
		-- Isso causa a perda de uma avaliação do filme, mas se utilazassemos "restrict"
		-- não poderiamos deletar a maioria das contas de usuário.
		on delete cascade,

	-- A nota do filme pode não estar presente se o filme ainda não foi avaliado,
	-- ou então deve ser uma nota entre 0 e 10, para que exista um limite no qual
	-- os usuários possam avaliar o filme.
	constraint movie_session_rating_should_be_null_or_between_zero_and_ten
		check(rating is null or rating between 0.0 and 10.0)
);

create table tv_show (
	name		text	not null,
	year		integer	not null,
	sinopsis	text,
	rating		real,

	constraint tv_show_pk
		primary key (name, year),
	
	-- A nota da série pode não estar presente se a série ainda não foi avaliada,
	-- ou então deve ser uma nota entre 0 e 10, para que exista um limite no qual
	-- os usuários possam avaliar o série.
	constraint tv_show_rating_should_be_null_or_between_zero_and_ten
		check(rating is null or rating between 0.0 and 10.0)
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
		foreign key (tv_show_name, tv_show_year) references tv_show (name, year)
		-- Se o nome ou ano da série for atualizado, atualize a referência. 
		on update cascade
		-- Se a série for removida, a temporada também deve ser.
		on delete cascade,

	-- A nota da temporada pode não estar presente se a temporada ainda não foi avaliada,
	-- ou então deve ser uma nota entre 0 e 10, para que exista um limite no qual
	-- os usuários possam avaliar a temporada.
	constraint season_rating_should_be_null_or_between_zero_and_ten
		check(rating is null or rating between 0.0 and 10.0)
);

create table provides_season (
	service					text	not null,
	catalogue				text	not null,
	tv_show_name			text	not null,
	tv_show_year			integer	not null,
	season					integer not null,
	season_link				text	not null,
	quality					text,
	purchase_available		boolean not null default(false),
	purchase_price			decimal(8, 2),
	rent_available			boolean not null default(false),
	rent_price				decimal(8, 2),
	rent_duration			interval,
	included_subscription	boolean,
	
	constraint provides_season_pk
		primary key	(service, catalogue, tv_show_name, tv_show_year, season),
	
	constraint provides_season_catalogue_fk
		foreign key (service, catalogue) references catalogue (service, country)
		-- Se o nome do serviço ou catálogo for alterado, atualize a referência.
		on update cascade
		-- Se o catálogo for deletado a temporada também deixa de ser disponibilizada.
		on delete cascade,
	
	constraint provides_season_season_fk
		foreign key (tv_show_name, tv_show_year, season)
		references season (tv_show_name, tv_show_year, number)
		-- Se o nome da série, ano ou número da temporada forem atualizados, atualize a
		-- referência.
		on update cascade
		-- Se uma temporada ainda é disponibilizada por algum catálogo, não faz sentido que
		-- permitir que a temporada seja deletada, afinal o próposito da aplicação
		-- é registrar todos filmes e séries disponíveis em um conjunto de serviços
		-- de streaming.
		on delete restrict,

	-- Se uma temporada pode ser comprada, ela precisa ter um preço registrado. Caso contrário
	-- o preço é um campo desconsiderado tanto se for nulo ou presente.
	constraint provides_season_if_purchaseable_must_have_price
		check(purchase_available = false or purchase_price is not null),

	-- Se uma temporada pode ser aluguel, ela precisa ter preço e duração de aluguel
	-- registrados. Caso contrário ambos campos são desconsiderados tanto se forem
	-- nulos ou presentes.
	constraint provides_season_if_rentable_must_have_price_and_duration
		check(rent_available = false or (rent_price is not null and rent_duration is not null))

	-- É completamente possível que uma temporada possa estar disponível para compra e/ou
	-- aluguel, ao mesmo tempo que é incluso com a assinatura. Já que alguem que não tem a
	-- assinatura pode prefirir comprar/ou alugar, em vez de assinar o serviço inteiro.
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
		-- Se a chave de disponibiliza temporada for alterada, atualize a refêrencia.
		on update cascade
		-- Se a temporada deixar de ser disponibilizada não é necessário manter informações
		-- sobre os idiomas disponíveis.
		on delete cascade
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
		-- Se a chave de disponibiliza temporada for alterada, atualize a refêrencia.
		on update cascade
		-- Se a temporada deixar de ser disponibilizada não é necessário manter informações
		-- sobre os idiomas disponíveis.
		on delete cascade
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
		-- Se o nome da série, ano ou número da temporada forem atualizados, atualize a
		-- referência.
		on update cascade
		-- Se a temporada for removida, remova também os episódios.
		on delete cascade
);

create table participates_in_episode (
	episode				uuid	not null,
	artist_name			text	not null,
	artist_birthday		date	not null,
	participation_type	text	not null,

	constraint participates_in_episode_pk
		primary key (episode, artist_name, artist_birthday),

	-- Justificativa sobre as as operações "on delete":
	--
	-- Episódios e Artistas são ambas entidades fortes, mas entre elas o foco do sistema é
	-- prover informações sobre o Episódio, e a entidade Artista só existe para armazenar
	-- metadados sobre Filmes e Séries.
	-- Dessa forma, deve se saber todos Artistas que participam nos Episódios cadastrados,
	-- mas não é necessário saber todos Episódios dos quais um Artista participou.

	constraint participates_in_episode_episode_fk
		foreign key (episode) references episode (id)
		-- Se o id do episódio for alterado, altere a referência também. 
		on update cascade
		-- Se o episódio for removido, as informações de participação devem ser removidas.
		on delete cascade,

	constraint participates_in_episode_artist_fk
		foreign key (artist_name, artist_birthday) references artist (name, birthday)
		-- Se o nome ou data de nascimento do artista forem alterados basta propagar a
		-- atualização.
		on update cascade
		-- Não deve ser permitido remover um artista que ainda participa de um episódio.
		on delete restrict,

	-- Checa que o tipo de participação é um dos valores permitidos. Os nomes devem ser
	-- exatamente iguais, por que é responsabilidade da aplicação utilizar os nomes corretos
	-- sem inconsistências de letras maíusculas ou mininusculas, e isso também simplifica
	-- a aplicação que não precisa aceitar todas variações possiveis também.
	constraint participates_in_movie_allowed_participation_types
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
		references participates_in_episode (episode, artist_name, artist_birthday)
		-- Se ocorrer alguma alteração no id do episódio ou nome/data de nascimento
		-- do artista podemos só atualizar a referência.
		on update cascade
		-- Se a participação for removida, a atuação tambem deve ser.
		on delete cascade,

	-- Checa que o tipo de atuação é um dos valores permitidos. Os nomes devem ser
	-- exatamente iguais, por que é responsabilidade da aplicação utilizar os nomes corretos
	-- sem inconsistências de letras maíusculas ou mininusculas, e isso também simplifica
	-- a aplicação que não precisa aceitar todas variações possiveis também.
	constraint acts_in_episode_allowed_act_types
		check(act_type in ('Acting', 'Dubbing')),
	
	-- Checa que o tipo de atuação é um dos valores permitidos. Os nomes devem ser
	-- exatamente iguais, por que é responsabilidade da aplicação utilizar os nomes corretos
	-- sem inconsistências de letras maíusculas ou mininusculas, e isso também simplifica
	-- a aplicação que não precisa aceitar todas variações possiveis também.
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
		foreign key (episode) references episode (id)
		-- Se o id do episódio for alterado basta propagar a atualização.
		on update cascade
		-- Se o episódio for deletado, podemos também remover todas as sessões e avaliações.
		on delete cascade,

	constraint episode_session_profile_fk
		foreign key ("user", profile) references profile ("user", name)
		-- Se o nome de usuário ou perfil forem alterados basta propagar a atualização.
		on update cascade
		-- Se o usuário for deletado, o histórico de visualizações também é removido.
		-- Isso causa a perda de uma avaliação do filme, mas se utilazassemos "restrict"
		-- não poderiamos deletar a maioria das contas de usuário.
		on delete cascade,

	-- A nota do filme pode não estar presente se o filme ainda não foi avaliado,
	-- ou então deve ser uma nota entre 0 e 10, para que exista um limite no qual
	-- os usuários possam avaliar o filme.
	constraint episode_session_rating_should_be_null_or_between_zero_and_ten
		check(rating is null or rating between 0.0 and 10.0)
);
