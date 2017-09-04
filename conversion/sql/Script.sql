/*
SELECT 
    --gs.fid, gem.bfs_gemein, gem.the_geom, gs.the_geom, gs."zone"
    count(*)
FROM
    agi_gemgre.gemeindegrenze AS gem, 
    afu_gws.public_aww_gszoar AS gs
--WHERE ST_Intersects(gem.the_geom, gs.the_geom)
--WHERE ST_ContainsProperly(gem.the_geom, gs.the_geom)
--WHERE ST_Intersects(gem.the_geom, gs.the_geom)
WHERE ST_Intersects(gem.the_geom, ST_Buffer(gs.the_geom, -1.0))
--AND NOT ST_Touches(gem.the_geom, gs.the_geom)
--ORDER BY gs.fid;
    

-- Am sinnvollsten? kleiner minus buffer und INTERSECT -> dann ist die Aussage relativ belastbar. 792 vs 763 vs. 665 (original)
*/

-- So noch nicht definitive Lösung.
DELETE FROM
	arp_npl_export.t_ili2db_dataset;

DELETE FROM
	arp_npl_export.t_ili2db_basket;

DELETE FROM 
	arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche;

WITH datasets AS (
	INSERT INTO arp_npl_export.t_ili2db_dataset (t_id, datasetname)
	SELECT 
		nextval('arp_npl_export.t_ili2db_seq'::regclass), bfs_gemein::varchar AS datasetname 
	FROM 
		agi_gemgre.gemeindegrenze AS g
	--WHERE bfs_gemein = 2502
	RETURNING *
),
-- Pro Gemeinde gäbe es einmal "Nutzungsplanung"?
baskets_nutzungsplanung AS (
	INSERT INTO arp_npl_export.t_ili2db_basket (t_id, dataset, topic, t_ili_tid, attachmentkey)
	SELECT 
		nextval('arp_npl_export.t_ili2db_seq'::regclass) AS t_id, t_id AS dataset, 
		'SO_Nutzungsplanung_20170901.Nutzungsplanung' AS topic,  'SO_Nutzungsplanung_20170901.Nutzungsplanung' AS t_ili_tid, 
		datasetname::varchar AS attachmentkey
	FROM 
		datasets
	RETURNING *
),


-- alle Gemeinden _mit_ Typ 593
-- Geht so eigentlich nicht mehr ganz auf:
-- code_kommunal ist UNIQUE. Wenn man aber mit datasets arbeitet,
-- werden zwangsläufig gleiche code_kommunal-Werte vorhanden sein.
typ_593 AS (
	INSERT INTO arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche (t_basket, t_datasetname, t_ili_tid, typ_kt, code_kommunal, bezeichnung, abkuerzung, verbindlichkeit)
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
		    DISTINCT gem.bfs_gemein::varchar AS datasetname, 'foo' AS bar
		FROM
		    agi_gemgre.gemeindegrenze AS gem, 
		    afu_gws.public_aww_gszoar AS gs
		WHERE gs."zone" = 'GZ1' 
		AND ST_Intersects(gem.the_geom, ST_Buffer(gs.the_geom, -1.0))
		ORDER BY datasetname
	) AS typen,
	datasets,
	baskets_nutzungsplanung
	WHERE typen.datasetname = datasets.datasetname
	AND baskets_nutzungsplanung.dataset = datasets.t_id
	RETURNING *
),
typ_594 AS (
	INSERT INTO arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche (t_basket, t_datasetname, t_ili_tid, typ_kt, code_kommunal, bezeichnung, abkuerzung, verbindlichkeit)
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
		    DISTINCT gem.bfs_gemein::varchar AS datasetname, 'foo' AS bar
		FROM
		    agi_gemgre.gemeindegrenze AS gem, 
		    afu_gws.public_aww_gszoar AS gs
		WHERE gs."zone" = 'GZ2' 
		AND ST_Intersects(gem.the_geom, ST_Buffer(gs.the_geom, -1.0))
		ORDER BY datasetname
	) AS typen,
	datasets,
	baskets_nutzungsplanung
	WHERE typen.datasetname = datasets.datasetname
	AND baskets_nutzungsplanung.dataset = datasets.t_id
	RETURNING *
)

SELECT 
	*
FROM
	typ_594;
	
	

	