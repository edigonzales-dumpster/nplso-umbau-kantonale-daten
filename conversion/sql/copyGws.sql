
/*
 * init-common-tables.sql has to be executed before!
*/


-- Delete all areas that belong to a 
-- Grundwasserschutzzonen und -areale type.
DELETE FROM 
	arp_npl_kantdaten_export.nutzungsplanung_ueberlagernd_flaeche
WHERE typ_ueberlagernd_flaeche IN 
(
	SELECT
		DISTINCT t_id
	FROM 
		arp_npl_kantdaten_export.nutzungsplanung_typ_ueberlagernd_flaeche
	WHERE typ_kt IN ('N593_Grundwasserschutzzone_S1', 'N594_Grundwasserschutzzone_S2', 'N595_Grundwasserschutzzone_S3', 'N596_Grundwasserschutzareal')
);

-- Delete all Grundwasserschutzzonen und -areale types.
DELETE FROM 
	arp_npl_kantdaten_export.nutzungsplanung_typ_ueberlagernd_flaeche
WHERE typ_kt IN ('N593_Grundwasserschutzzone_S1', 'N594_Grundwasserschutzzone_S2', 'N595_Grundwasserschutzzone_S3', 'N596_Grundwasserschutzareal');
	
-- Achtung:
-- code_kommunal ist UNIQUE. Wenn man aber mit datasets arbeitet,
-- werden zwangsläufig gleiche code_kommunal-Werte vorhanden sein.
WITH typ_593 AS (
	INSERT INTO arp_npl_kantdaten_export.nutzungsplanung_typ_ueberlagernd_flaeche (t_basket, t_datasetname, t_ili_tid, typ_kt, code_kommunal, bezeichnung, abkuerzung, verbindlichkeit)
	SELECT 	
		baskets_nutzungsplanung.t_id AS t_basket,
		datasets.datasetname AS t_datasetname,
		uuid_generate_v4() AS t_ili_tid,
		'N593_Grundwasserschutzzone_S1' AS typ_kt, 
		'5930' AS code_kommunal,
		'Grundwasserschutzzone S1' AS bezeichnung, 
		'GRSZ1' AS abkuerzung,
		'orientierend' AS verbindlichkeit
	FROM
	(
		SELECT 
		    DISTINCT gem.bfs_gemeindenummer::varchar AS datasetname
		FROM
		    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gem, 
		    aww_gszoar AS gs
		WHERE (gs."zone" = 'GZ1' OR gs."zone" = 'GZ1B')
		AND gs."archive" = 0		
		AND ST_Intersects(gem.geometrie, ST_Buffer(gs.wkb_geometry, -1.0))
		ORDER BY datasetname
	) AS typen,
	arp_npl_kantdaten_export.t_ili2db_dataset AS datasets,
	arp_npl_kantdaten_export.t_ili2db_basket AS baskets_nutzungsplanung
	WHERE typen.datasetname = datasets.datasetname
	AND baskets_nutzungsplanung.dataset = datasets.t_id
	RETURNING *
),
typ_594 AS (
	INSERT INTO arp_npl_kantdaten_export.nutzungsplanung_typ_ueberlagernd_flaeche (t_basket, t_datasetname, t_ili_tid, typ_kt, code_kommunal, bezeichnung, abkuerzung, verbindlichkeit)
	SELECT 	
		baskets_nutzungsplanung.t_id AS t_basket,
		datasets.datasetname AS t_datasetname,
		uuid_generate_v4() AS t_ili_tid,
		'N594_Grundwasserschutzzone_S2' AS typ_kt, 
		'5940' AS code_kommunal,
		'Grundwasserschutzzone S2' AS bezeichnung, 
		'GRSZ2' AS abkuerzung,
		'orientierend' AS verbindlichkeit
	FROM
	(
		SELECT 
		    DISTINCT gem.bfs_gemeindenummer::varchar AS datasetname
		FROM
		    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gem, 
		    aww_gszoar AS gs
		WHERE (gs."zone" = 'GZ2' OR gs."zone" = 'GZ2B')
		AND gs."archive" = 0		
		AND ST_Intersects(gem.geometrie, ST_Buffer(gs.wkb_geometry, -1.0))
		ORDER BY datasetname
	) AS typen,
	arp_npl_kantdaten_export.t_ili2db_dataset AS datasets,
	arp_npl_kantdaten_export.t_ili2db_basket AS baskets_nutzungsplanung
	WHERE typen.datasetname = datasets.datasetname
	AND baskets_nutzungsplanung.dataset = datasets.t_id
	RETURNING *
),
typ_595 AS (
	INSERT INTO arp_npl_kantdaten_export.nutzungsplanung_typ_ueberlagernd_flaeche (t_basket, t_datasetname, t_ili_tid, typ_kt, code_kommunal, bezeichnung, abkuerzung, verbindlichkeit)
	SELECT 	
		baskets_nutzungsplanung.t_id AS t_basket,
		datasets.datasetname AS t_datasetname,
		uuid_generate_v4() AS t_ili_tid,
		'N595_Grundwasserschutzzone_S3' AS typ_kt, 
		'5950' AS code_kommunal,
		'Grundwasserschutzzone S3' AS bezeichnung, 
		'GRSZ3' AS abkuerzung,
		'orientierend' AS verbindlichkeit
	FROM
	(
		SELECT 
		    DISTINCT gem.bfs_gemeindenummer::varchar AS datasetname
		FROM
		    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gem, 
		    aww_gszoar AS gs
		WHERE (gs."zone" = 'GZ3' OR gs."zone" = 'GZ3B')
		AND gs."archive" = 0		
		AND ST_Intersects(gem.geometrie, ST_Buffer(gs.wkb_geometry, -1.0))
		ORDER BY datasetname
	) AS typen,
	arp_npl_kantdaten_export.t_ili2db_dataset AS datasets,
	arp_npl_kantdaten_export.t_ili2db_basket AS baskets_nutzungsplanung
	WHERE typen.datasetname = datasets.datasetname
	AND baskets_nutzungsplanung.dataset = datasets.t_id
	RETURNING *
),
typ_596 AS (
	INSERT INTO arp_npl_kantdaten_export.nutzungsplanung_typ_ueberlagernd_flaeche (t_basket, t_datasetname, t_ili_tid, typ_kt, code_kommunal, bezeichnung, abkuerzung, verbindlichkeit)
	SELECT 	
		baskets_nutzungsplanung.t_id AS t_basket,
		datasets.datasetname AS t_datasetname,
		uuid_generate_v4() AS t_ili_tid,
		'N596_Grundwasserschutzareal' AS typ_kt, 
		'5960' AS code_kommunal,
		'Grundwasserschutzareal' AS bezeichnung, 
		'GRSA' AS abkuerzung,
		'orientierend' AS verbindlichkeit
	FROM
	(
		SELECT 
		    DISTINCT gem.bfs_gemeindenummer::varchar AS datasetname
		FROM
		    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gem, 
		    aww_gszoar AS gs
		WHERE gs."zone" = 'SARE'
		AND gs."archive" = 0		
		AND ST_Intersects(gem.geometrie, ST_Buffer(gs.wkb_geometry, -1.0))
		ORDER BY datasetname
	) AS typen,
	arp_npl_kantdaten_export.t_ili2db_dataset AS datasets,
	arp_npl_kantdaten_export.t_ili2db_basket AS baskets_nutzungsplanung
	WHERE typen.datasetname = datasets.datasetname
	AND baskets_nutzungsplanung.dataset = datasets.t_id
	RETURNING *
),
geometrie_593 AS (
	INSERT INTO arp_npl_kantdaten_export.nutzungsplanung_ueberlagernd_flaeche 
		(t_basket, t_datasetname, t_ili_tid, name_nummer, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie)
	SELECT 
		t_basket, t_databasename, t_ili_tid, name_nummer, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie
	FROM (		
		SELECT 
		   	typ_593.t_basket AS t_basket,
			gem.bfs_gemeindenummer::varchar AS t_databasename,
			uuid_generate_v4() AS t_ili_tid,
		   	date_part('year', rrb_date) || '/' || rrbnr::varchar AS name_nummer,
		   	'inKraft' AS rechtsstatus,
		   	rrb_date AS publiziertab,
		   	'AFU' AS erfasser,
		   	new_date AS datum,
		   	typ_593.t_id AS typ_ueberlagernd_flaeche,
			(ST_Dump(ST_Intersection(gs.wkb_geometry, gem.geometrie))).geom AS geometrie
		FROM
		    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gem, 
		    aww_gszoar AS gs,
		    typ_593
		WHERE (gs."zone" = 'GZ1' OR gs."zone" = 'GZ1B')
		AND gs."archive" = 0		
		AND ST_Intersects(gem.geometrie, ST_Buffer(gs.wkb_geometry, -1.0))
		AND typ_593.t_datasetname = gem.bfs_gemeindenummer::varchar
	) AS foo
	WHERE ST_GeometryType(geometrie) = 'ST_Polygon'
	RETURNING *
),
geometrie_594 AS (
	INSERT INTO arp_npl_kantdaten_export.nutzungsplanung_ueberlagernd_flaeche 
		(t_basket, t_datasetname, t_ili_tid, name_nummer, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie)
	SELECT 
		t_basket, t_databasename, t_ili_tid, name_nummer, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie
	FROM (
		SELECT 
		   	typ_594.t_basket AS t_basket,
			gem.bfs_gemeindenummer::varchar AS t_databasename,
			uuid_generate_v4() AS t_ili_tid,
		   	date_part('year', rrb_date) || '/' || rrbnr::varchar AS name_nummer,
		   	'inKraft' AS rechtsstatus,
		   	rrb_date AS publiziertab,
		   	'AFU' AS erfasser,
		   	new_date AS datum,
		   	typ_594.t_id AS typ_ueberlagernd_flaeche,
			(ST_Dump(ST_Intersection(gs.wkb_geometry, gem.geometrie))).geom AS geometrie
		FROM
		    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gem, 
		    aww_gszoar AS gs,
		    typ_594
		WHERE (gs."zone" = 'GZ2' OR gs."zone" = 'GZ2B')
		AND gs."archive" = 0		
		AND ST_Intersects(gem.geometrie, ST_Buffer(gs.wkb_geometry, -1.0))
		AND typ_594.t_datasetname = gem.bfs_gemeindenummer::varchar
	) AS foo
	WHERE ST_GeometryType(geometrie) = 'ST_Polygon'
	RETURNING *
),
geometrie_595 AS (
	INSERT INTO arp_npl_kantdaten_export.nutzungsplanung_ueberlagernd_flaeche 
		(t_basket, t_datasetname, t_ili_tid, name_nummer, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie)
	SELECT 
		t_basket, t_databasename, t_ili_tid, name_nummer, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie
	FROM (
		SELECT 
		   	typ_595.t_basket AS t_basket,
			gem.bfs_gemeindenummer::varchar AS t_databasename,
			uuid_generate_v4() AS t_ili_tid,
		   	date_part('year', rrb_date) || '/' || rrbnr::varchar AS name_nummer,
		   	'inKraft' AS rechtsstatus,
		   	rrb_date AS publiziertab,
		   	'AFU' AS erfasser,
		   	new_date AS datum,
		   	typ_595.t_id AS typ_ueberlagernd_flaeche,
			(ST_Dump(ST_Intersection(gs.wkb_geometry, gem.geometrie))).geom AS geometrie
		FROM
	    	agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gem, 
		    	aww_gszoar AS gs,
		    typ_595
		WHERE (gs."zone" = 'GZ3' OR gs."zone" = 'GZ3B')
		AND gs."archive" = 0
		AND ST_Intersects(gem.geometrie, ST_Buffer(gs.wkb_geometry, -1.0))
		AND typ_595.t_datasetname = gem.bfs_gemeindenummer::varchar
	) AS foo
	WHERE ST_GeometryType(geometrie) = 'ST_Polygon'
	RETURNING *
)
-- geometrie_596
INSERT INTO arp_npl_kantdaten_export.nutzungsplanung_ueberlagernd_flaeche 
	(t_basket, t_datasetname, t_ili_tid, name_nummer, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie)
SELECT 
	t_basket, t_databasename, t_ili_tid, name_nummer, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie
FROM (
	SELECT 
	   	typ_596.t_basket AS t_basket,
		gem.bfs_gemeindenummer::varchar AS t_databasename,
		uuid_generate_v4() AS t_ili_tid,
	   	date_part('year', rrb_date) || '/' || rrbnr::varchar AS name_nummer,
	   	'inKraft' AS rechtsstatus,
	   	rrb_date AS publiziertab,
	   	'AFU' AS erfasser,
	   	new_date AS datum,
	   	typ_596.t_id AS typ_ueberlagernd_flaeche,
		(ST_Dump(ST_Intersection(gs.wkb_geometry, gem.geometrie))).geom AS geometrie
	FROM
    	agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gem, 
	    	aww_gszoar AS gs,
	    typ_596
	WHERE gs."zone" = 'SARE'
	AND gs."archive" = 0
	AND ST_Intersects(gem.geometrie, ST_Buffer(gs.wkb_geometry, -1.0))
	AND typ_596.t_datasetname = gem.bfs_gemeindenummer::varchar
) AS foo
WHERE ST_GeometryType(geometrie) = 'ST_Polygon';	

	