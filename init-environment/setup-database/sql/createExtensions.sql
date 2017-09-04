--CREATE EXTENSION IF NOT EXISTS postgis;
--CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SELECT UpdateGeometrySRID('afu_gws', 'public_aww_gszoar','the_geom',2056);