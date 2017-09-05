
/*
 * init-common-tables.sql has to be executed before!
*/


-- Delete all areas that belong to a 
-- BLN type.
DELETE FROM 
	arp_npl_export.nutzungsplanung_ueberlagernd_flaeche
WHERE typ_ueberlagernd_flaeche IN 
(
	SELECT
		DISTINCT t_id
	FROM 
		arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche
	WHERE typ_kt = 'N520_BLN_Gebiet'
);

-- Delete BLN type.
DELETE FROM 
	arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche
WHERE typ_kt = 'N520_BLN_Gebiet';


WITH typ_520 AS (
	INSERT INTO arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche (t_basket, t_datasetname, t_ili_tid, typ_kt, code_kommunal, bezeichnung, abkuerzung, verbindlichkeit)
	SELECT 	
		baskets_nutzungsplanung.t_id AS t_basket,
		datasets.datasetname AS t_datasetname,
		uuid_generate_v4() AS t_ili_tid,
		'N520_BLN_Gebiet' AS typ_kt, 
		'5200' AS code_kommunal,
		'BLN Gebiet' AS bezeichnung, 
		'BLN' AS abkuerzung,
		'hinweisend' AS verbindlichkeit
	FROM
	(
		SELECT 
		    DISTINCT gem.bfs_gemein::varchar AS datasetname
		FROM
		    agi_gemgre.gemeindegrenze AS gem, 
		    arp_bln.bln_bln AS b
		WHERE ST_Intersects(gem.the_geom, ST_Buffer(b.geo_obj, -1.0))
		ORDER BY datasetname
	) AS typen,
	arp_npl_export.t_ili2db_dataset AS datasets,
	arp_npl_export.t_ili2db_basket AS baskets_nutzungsplanung
	WHERE typen.datasetname = datasets.datasetname
	AND baskets_nutzungsplanung.dataset = datasets.t_id
	RETURNING *
),
geometrie_520 AS (
	INSERT INTO arp_npl_export.nutzungsplanung_ueberlagernd_flaeche 
		(t_basket, t_datasetname, t_ili_tid, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie)
	SELECT 
		t_basket, t_databasename, t_ili_tid, rechtsstatus, publiziertab, erfasser, datum, typ_ueberlagernd_flaeche, geometrie
	FROM (		
		SELECT 
		   	typ_520.t_basket AS t_basket,
			gem.bfs_gemein::varchar AS t_databasename,
			uuid_generate_v4() AS t_ili_tid,
		   	'inKraft' AS rechtsstatus,
		   	inkraftsetzungsdatum AS publiziertab,
		   	'ARP' AS erfasser,
		   	now() AS datum,
		   	typ_520.t_id AS typ_ueberlagernd_flaeche,
			(ST_Dump(ST_Intersection(b.geo_obj, gem.the_geom))).geom AS geometrie
		FROM
		    agi_gemgre.gemeindegrenze AS gem, 
		    arp_bln.bln_bln AS b,
		    typ_520
		WHERE ST_Intersects(gem.the_geom, ST_Buffer(b.geo_obj, -1.0))
		AND typ_520.t_datasetname = gem.bfs_gemein::varchar
	) AS foo
	WHERE ST_GeometryType(geometrie) = 'ST_Polygon'
	RETURNING *
)
SELECT
	*
FROM
	geometrie_520
