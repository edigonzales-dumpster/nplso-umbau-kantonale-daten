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
	RETURNING *
),
-- Pro Gemeinde gäbe es einmal "Nutzungsplanung"?
baskets_nutzungsplanung AS (
	INSERT INTO arp_npl_export.t_ili2db_basket (t_id, dataset, topic, t_ili_tid, attachmentkey)
	SELECT 
		nextval('arp_npl_export.t_ili2db_seq'::regclass) AS t_id, t_id AS dataset, 
		'SO_Nutzungsplanung_20170105.Nutzungsplanung' AS topic,  'SO_Nutzungsplanung_20170105.Nutzungsplanung' AS t_ili_tid, 
		datasetname::varchar AS attachmentkey
	FROM 
		datasets
	RETURNING *
),
-- alle Gemeinden _mit_ Typ 593
typ_593 AS (
	INSERT INTO arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche (t_basket, t_datasetname, typ_kt, code_kommunal, bezeichnung, abkuerzung, verbindlichkeit)
	SELECT 	
		baskets_nutzungsplanung.t_id AS t_basket,
		datasets.datasetname AS t_datasetname,
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
)

SELECT 
	*
FROM
	typ_593;
	
	

	