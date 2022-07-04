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


select distinct a.*, avg((m.rating + ts.rating) / 2) as rating, count(m.name) as movies_count,
  count(ts.name) as tv_shows_count
from
  acts_in_movie am
inner join movie m
  on (am.movie_name = m.name and am.movie_year = m.year)
inner join acts_in_episode ae 
  on (am.artist_name = ae.artist_name and am.artist_birthday = ae.artist_birthday)
inner join episode e
  on (ae.episode = e.id)
inner join tv_show ts
  on (e.tv_show_name = ts.name and e.tv_show_year = ts.year)
inner join artist a
  on (am.artist_name = a.name and am.artist_birthday = a.birthday)
where
  am.act_type = 'Acting'
group by
  (a.name, a.birthday)
order by
  avg((m.rating + ts.rating) / 2)

set search_path to streaming_service_agregator, public;

select distinct on (m.name, ts.name)
  a.*, ((m.rating + ts.rating) / 2) as rating, *
--a.*, m.name, m.rating, count(m.name) over (partition by m.name), e.id, e.season, ts.name, ts.rating
 --a.*, count(m.name), count(distinct m.name), count(ts.name), count(distinct ts.name), avg(m.rating)
 -- a.*, -- avg((m.rating + ts.rating) / 2) as rating, count(m.name) as movies_count,
  --count(ts.name) as tv_shows_count
from
  artist a
  
left join acts_in_movie am
  on (a.name = am.artist_name and a.birthday = am.artist_birthday)
left join movie m
  on (am.movie_name = m.name and am.movie_year = m.year)

left join acts_in_episode ae
  on (a.name = ae.artist_name and a.birthday = ae.artist_birthday)

left join episode e
  on (ae.episode = e.id)
left join tv_show ts
  on (e.tv_show_name = ts.name and e.tv_show_year = ts.year)
--order by ((m.rating + ts.rating) / 2)
--group by (a.name, a.birthday)
--  avg((m.rating + ts.rating) / 2)

