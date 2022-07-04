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
	ps.included_in_subscription = true
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
	rating = ar.rating
from
	avg_ratings ar
where
	m.name = ar.movie_name
	and
	m.year = ar.movie_year;
