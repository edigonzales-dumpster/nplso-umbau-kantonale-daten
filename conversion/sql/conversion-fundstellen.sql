
/*
 * init-common-tables.sql has to be executed before!
*/

-- Delete all areas that belong to a Fundstellen type.
DELETE FROM 
	arp_npl_export.nutzungsplanung_ueberlagernd_flaeche
WHERE typ_ueberlagernd_flaeche IN 
(
	SELECT
		DISTINCT t_id
	FROM 
		arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche
	WHERE typ_kt = 'N699_weitere_flaechenbezogene_Festlegungen_NP'
);



-- SAME FOR POINTS!!!!!!!!

-- Delete Fundstellen types.
DELETE FROM 
	arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche
WHERE typ_kt = 'N699_weitere_flaechenbezogene_Festlegungen_NP';



WITH typ_699 AS (
	INSERT INTO arp_npl_export.nutzungsplanung_typ_ueberlagernd_flaeche (t_basket, t_datasetname, t_ili_tid, typ_kt, code_kommunal, bezeichnung, verbindlichkeit)
	SELECT 	
		baskets_nutzungsplanung.t_id AS t_basket,
		datasets.datasetname AS t_datasetname,
		uuid_generate_v4() AS t_ili_tid,
		'N699_weitere_flaechenbezogene_Festlegungen_NP' AS typ_kt, 
		'6991' AS code_kommunal,
		'Geschützte archäologische Fundstellen' AS bezeichnung, 
		'hinweisend' AS verbindlichkeit
	FROM
	(
		SELECT 
		    DISTINCT gem.bfs_gemein::varchar AS datasetname
		FROM
		    agi_gemgre.gemeindegrenze AS gem, 
		    ada_adagis_a.flaechenfundstellen AS fund
		WHERE fund."archive" = 'f'
		AND fund.geschuetzt = 't'
		AND ST_Intersects(gem.the_geom, ST_Buffer(fund.the_geom, -1.0))
		ORDER BY datasetname
	) AS typen,
	arp_npl_export.t_ili2db_dataset AS datasets,
	arp_npl_export.t_ili2db_basket AS baskets_nutzungsplanung
	WHERE typen.datasetname = datasets.datasetname
	AND baskets_nutzungsplanung.dataset = datasets.t_id
	RETURNING *
),
geometrie_699 AS (
	INSERT INTO arp_npl_export.nutzungsplanung_ueberlagernd_flaeche 
		(t_basket, t_datasetname, t_ili_tid, rechtsstatus, publiziertab, bemerkungen, erfasser, datum, typ_ueberlagernd_flaeche, geometrie)
	SELECT 
		t_basket, t_databasename, t_ili_tid, rechtsstatus, publiziertab, bemerkungen, erfasser, datum, typ_ueberlagernd_flaeche, geometrie
	FROM (		
		SELECT 
		   	typ_699.t_basket AS t_basket,
			gem.bfs_gemein::varchar AS t_databasename,
			uuid_generate_v4() AS t_ili_tid,
		   	'inKraft' AS rechtsstatus,
		   	'2999-12-31'::date AS publiziertab,
		   	fund.art AS bemerkungen,
		   	'ADA' AS erfasser,
		   	now() AS datum,
		   	typ_699.t_id AS typ_ueberlagernd_flaeche,
			(ST_Dump(ST_Intersection(fund.the_geom, gem.the_geom))).geom AS geometrie
		FROM
		    agi_gemgre.gemeindegrenze AS gem, 
		    ada_adagis_a.flaechenfundstellen AS fund,
		    typ_699
		WHERE fund."archive" = 'f'
		AND fund.geschuetzt = 't'
		AND ST_Intersects(gem.the_geom, ST_Buffer(fund.the_geom, -1.0))
		AND typ_699.t_datasetname = gem.bfs_gemein::varchar
	) AS foo
	WHERE ST_GeometryType(geometrie) = 'ST_Polygon'
	RETURNING *
)
SELECT
	*
FROM
	geometrie_699