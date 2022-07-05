set search_path to streaming_service_agregator, public;

-- Achar todas as séries em que um ator tem um papel principal, e está inclusa
-- na assinatura de um serviço que usuário assina.
select ts.*
from subscribe sub

inner join catalogue c
	on (c.service = sub.service)

inner join provides_season ps
	on (c.service = ps.service and c.country = ps.catalogue)

inner join episode e
	on (ps.tv_show_name = e.tv_show_name and ps.tv_show_year = e.tv_show_year
		and ps.season = e.season)

inner join acts_in_episode ae
	on (e.id = ae.episode)
	
inner join tv_show ts
	on (e.tv_show_name = ts.name and e.tv_show_year = ts.year)
where
	sub."user" = 'dmdemoura'
	and
	c.country = 'brasil'
	and
	ps.included_subscription = true
	and
	ae.artist_name ilike '%Brad Pitt%'
	and
	ae.role_type = 'Main';


-- Atualiza a nota do filme a partir das avaliações deixadas pelos perfis
with
	ratings as ( 
		select 
			distinct on (ms.movie_name, ms.movie_year, ms.user, ms.profile)
			ms.movie_name, ms.movie_year, last_value(rating) over w as last_rating
		from
			movie_session ms
		where
			rating is not null
		window w as (
			partition by ms.movie_name, ms.movie_year, ms.user, ms.profile
			order by start_time asc
			rows between unbounded preceding and unbounded following
		)
	),
	avg_ratings as (
		select
			r.movie_name, r.movie_year, avg(r.last_rating) as avg_rating
		from ratings r
		group by 
			(r.movie_name, r.movie_year);
	)
update
	movie m
set	
	rating = ar.avg_rating
from
	avg_ratings ar
where
	m.name = ar.movie_name
	and
	m.year = ar.movie_year;


-- Atualiza a nota da temporada a partir das avaliações deixadas pelos perfis
with
	episode_ratings as ( 
		select 
			distinct on (es.episode, es.user, es.profile)
			es.episode, last_value(es.rating) over w as last_rating
		from
			episode_session es
		where
			es.rating is not null
		window w as (
			partition by es.episode, es.user, es.profile
			order by start_time asc
			rows between unbounded preceding and unbounded following
		)
	),
	avg_season_ratings as (
		select
			e.tv_show_name, e.tv_show_year, e.season, avg(er.last_rating) as avg_rating
		from
			episode_ratings er, episode e
		where
			er.episode = e.id
		group by 
			(e.tv_show_name, e.tv_show_year, e.season)
	)
update
	season s
set	
	rating = asr.avg_rating
from
	avg_season_ratings asr
where
	s.tv_show_name = asr.tv_show_name
	and
	s.tv_show_year = asr.tv_show_year
	and
	s.number = asr.season;

-- Atualiza a nota da série com base na nota das temporadas.
with
	avg_tv_show_ratings as (
		select
			s.tv_show_name, s.tv_show_year, avg(s.rating) as avg_rating
		from season s
		group by
			(s.tv_show_name, s.tv_show_year)
	)
update
	tv_show ts
set
	rating = r.avg_rating
from
	avg_tv_show_ratings r
where
	r.tv_show_name = ts.name
	and
	r.tv_show_year = ts.year;


-- Seleciona os próximos episódios a assitir ou continuar a assistir, 
-- com base nos episódios já assistidos e a disponibilidade na assinatura.
select distinct on (e.tv_show_name, e.tv_show_year, e.season)
	e.tv_show_name, e.tv_show_year, e.number, s.sinopsis,
	
	case last_value(es.finished) over w
		when true then last_value(e.number) over w + 1
		else last_value(e.number) over w
	end as episode_to_watch,
	
	case last_value(es.finished) over w
		when true then '0'
		else last_value(es.watched_duration) over w
	end as continue_at

from subscribe sub

inner join catalogue c
	on (c.service = sub.service)

inner join provides_season ps
	on (c.service = ps.service and c.country = ps.catalogue)

inner join episode e
	on (ps.tv_show_name = e.tv_show_name and ps.tv_show_year = e.tv_show_year
		and ps.season = e.season)

inner join episode_session es
	on (es.episode = e.id)
	
inner join season s
	on (e.tv_show_name = s.tv_show_name and e.tv_show_year = s.tv_show_year and e.season = s.number)

where
	sub."user" = 'dmdemoura'
	and
	c.country = 'brasil'
	and
	ps.included_subscription = true

window w as (
	partition by e.tv_show_name, e.tv_show_year, e.season
	order by e.number asc
	rows between unbounded preceding and unbounded following
);


-- Seleciona todas artistas ordenados por uma "nota de artista", calculada fazendo 
-- uma média das notas de todos os filmes e séries em que o artista teve uma atuação
-- principal em.
with 
	-- Seleciona a média da nota dos filmes, e a quantidade de filmes feitos por cada artista.
	artist_movie_ratings as (
		select
			am.artist_name, am.artist_birthday,
			avg(m.rating) as avg_rating,
			count(distinct (m.name, m.year)) as rating_count
		from
			acts_in_movie am
		inner join movie m
			on (am.movie_name = m.name and am.movie_year = m.year)
		where
			-- Só contar atuações principais
			am.role_type = 'Main'
		group by
			(am.artist_name, am.artist_birthday)
	),
	-- Seleciona a média da nota das séries, e a quantidade de séries feitas por cada artista
	artist_tv_show_ratings as (
		select
			ae.artist_name, ae.artist_birthday,
			avg(ts.rating) as avg_rating,
			count(distinct (ts.name, ts.year)) as rating_count
		from
			acts_in_episode ae
		inner join episode e
			on (ae.episode = e.id)
		inner join tv_show ts
			on (e.tv_show_name = ts.name and e.tv_show_year = ts.year)
		where
			-- Só contar atuações principais
			ae.role_type = 'Main'
		group by
			(ae.artist_name, ae.artist_birthday)
	)
select
	a.*,
	case
		-- coalesce() retorna o primeiro valor não nulo dos parametros passados.
		-- Utilizada para melhorar a legibilidade da query.

		when coalesce(amr.rating_count, 0) + coalesce(atr.rating_count, 0) = 0
			-- Não existe nota para filmes ou séries, o artista deve 
			-- ficar então com nota mínima.
			then 0
	
		when coalesce(amr.rating_count, 0) = 0
			-- Só existe nota para séries, use ela.
			then atr.avg_rating
		
		when coalesce(atr.rating_count, 0) = 0
			-- Só existe nota para filmes, use ela.
			then amr.avg_rating
		
		else
			-- Existem notas de filme e de série, então use uma média
			-- ponderada para obter a média correta de acordo com a quantidade
			-- de séries e filmes em que o artista atuou.
			(amr.rating_count * amr.avg_rating + atr.rating_count * atr.avg_rating)
				/ (amr.rating_count + atr.rating_count)

	end as artist_rating
from
	artist a
-- Utilizar left joins para listarmos também artistas que não participam 
-- tanto de filmes como séries, ou que não participam de nenhum.
left join artist_movie_ratings amr
	on (a.name = amr.artist_name and a.birthday = amr.artist_birthday)
left join artist_tv_show_ratings atr
	on (a.name = atr.artist_name and a.birthday = atr.artist_birthday)
-- Ordena os artista pela nota calculada
order by
	artist_rating desc;
