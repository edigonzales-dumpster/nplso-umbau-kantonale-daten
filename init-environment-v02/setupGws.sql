CREATE SCHEMA IF NOT EXISTS aww_gszoar;

CREATE TABLE aww_gszoar (
	ogc_fid serial,
	wkb_geometry geometry (MultiPolygon,2056),
	"zone" varchar NULL,
	new_date date NULL DEFAULT 'now'::text::date,
	archive_date date NULL DEFAULT '9999-01-01'::date,
	"archive" int2 NULL DEFAULT 0,
	rrbnr int4 NULL,
	rrb_date date NULL,
	CONSTRAINT aww_gszoar_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=FALSE
);
CREATE INDEX IF NOT EXISTS aww_gszoar_wkb_geometry_idx ON public.aww_gszoar USING GIST (wkb_geometry);
