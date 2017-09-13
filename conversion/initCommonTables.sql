-- Delete all datasets (= Gemeinden).
DELETE FROM
	arp_npl_export.t_ili2db_dataset;

-- Delete "Nutzungsplanung"-Basket from table.
DELETE FROM
	arp_npl_export.t_ili2db_basket
WHERE topic = 'SO_Nutzungsplanung_20170901.Nutzungsplanung';
	

-- Create one dataset per municipality.
-- Every dataset gets one "Nutzungsplanung" basket.
-- This basket holds all tables from the topic
-- "Nutzungsplanung".
WITH datasets AS (
	INSERT INTO arp_npl_export.t_ili2db_dataset (t_id, datasetname)
	SELECT 
		nextval('arp_npl_export.t_ili2db_seq'::regclass), bfs_gemeindenummer::varchar AS datasetname 
	FROM 
		agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g
	--WHERE bfs_gemein = 2502
	RETURNING *
)
-- baskets_nutzungsplanung
INSERT INTO arp_npl_export.t_ili2db_basket (t_id, dataset, topic, t_ili_tid, attachmentkey)
SELECT 
	nextval('arp_npl_export.t_ili2db_seq'::regclass) AS t_id, t_id AS dataset, 
	'SO_Nutzungsplanung_20170901.Nutzungsplanung' AS topic,  'SO_Nutzungsplanung_20170901.Nutzungsplanung' AS t_ili_tid, 
	datasetname::varchar AS attachmentkey
FROM 
	datasets;
