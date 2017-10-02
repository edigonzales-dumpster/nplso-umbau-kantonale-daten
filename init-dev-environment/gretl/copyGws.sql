SELECT 
	ogc_fid,
	ST_Multi(wkb_geometry) as wkb_geometry,
	"zone",
	new_date,
	archive_date,
	"archive",
	rrbnr,
	rrb_date
FROM
	aww_gszoar;