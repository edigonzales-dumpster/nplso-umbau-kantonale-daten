SELECT 
   	(ST_Dump(ST_Intersection(gs.the_geom, gem.the_geom))).geom AS geometrie,
   	date_part('year', rrb_date) || '/' || rrbnr::varchar AS name_nummer,
   	'inKraft' AS rechtsstatus,
   	rrb_date AS publiziertab,
   	'AFU' AS erfasser,
   	new_date AS datum,
   	gem.bfs_gemein::varchar AS t_databasename
FROM
    agi_gemgre.gemeindegrenze AS gem, 
    afu_gws.public_aww_gszoar AS gs
WHERE (gs."zone" = 'GZ1' OR gs."zone" = 'GZ1B')
AND ST_Intersects(gem.the_geom, ST_Buffer(gs.the_geom, -1.0))

