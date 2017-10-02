CREATE SCHEMA IF NOT EXISTS ada_adagis_a;

CREATE TABLE IF NOT EXISTS ada_adagis_a.flaechenfundstellen (
	ogc_fid serial,
	gemeindenummer int4 NOT NULL,
	laufnummer int4 NOT NULL,
	fundstellennummer varchar(10) NOT NULL,
	gemeinde varchar(512) NOT NULL,
	flurname_adresse varchar(512) NOT NULL,
	art varchar(512) NOT NULL,
	geschuetzt bool NOT NULL,
	qualitaet_lokalisierung varchar(256) NOT NULL,
	kurzbeschreibung varchar NOT NULL,
	grundbuchnummer varchar NOT NULL,
	koord_x int4 NOT NULL,
	koord_y int4 NOT NULL,
	hoehe int4 NOT NULL,
	landeskarte int4 NOT NULL,
	"archive" bool NOT NULL,
	archive_date timestamptz NULL DEFAULT '9999-01-01 00:00:00+01'::timestamp with time zone,
	new_date timestamptz NOT NULL DEFAULT now(),
	geometrie geometry(Polygon, 2056) NULL,
	"source" varchar(10) NULL,
	--"user" varchar(10) NULL,
	status varchar(20) NULL DEFAULT 'geaendert'::character varying,
	CONSTRAINT flaechenfundstellen_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=FALSE
);
CREATE INDEX IF NOT EXISTS flaechenfundstellen_geometrie_idx ON ada_adagis_a.flaechenfundstellen USING GIST (geometrie);

CREATE TABLE IF NOT EXISTS ada_adagis_a.punktfundstellen (
	ogc_fid serial,
	gemeindenummer int4 NOT NULL,
	laufnummer int4 NOT NULL,
	fundstellennummer varchar(10) NOT NULL,
	gemeinde varchar(512) NOT NULL,
	flurname_adresse varchar(512) NOT NULL,
	art varchar(512) NOT NULL,
	geschuetzt bool NOT NULL,
	qualitaet_lokalisierung varchar(256) NOT NULL,
	kurzbeschreibung varchar NOT NULL,
	grundbuchnummer varchar NOT NULL,
	koord_x int4 NOT NULL,
	koord_y int4 NOT NULL,
	hoehe int4 NOT NULL,
	landeskarte int4 NOT NULL,
	"archive" bool NOT NULL,
	archive_date timestamptz NULL DEFAULT '9999-01-01 00:00:00+01'::timestamp with time zone,
	new_date timestamptz NOT NULL DEFAULT now(),
	geometrie geometry(Point, 2056) NULL,
	"source" varchar(10) NULL,
	--"user" varchar(10) NULL,
	status varchar(20) NULL DEFAULT 'geaendert'::character varying,
	CONSTRAINT punktfundstellen_pkey PRIMARY KEY (ogc_fid)
)
WITH (
	OIDS=FALSE
);
CREATE INDEX IF NOT EXISTS punktfundstellen_geometrie_idx ON ada_adagis_a.punktfundstellen USING GIST (geometrie);
