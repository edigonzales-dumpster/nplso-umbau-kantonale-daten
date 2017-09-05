CREATE SEQUENCE arp_bln.t_ili2db_seq;;
-- GeometryCHLV95_V1.SurfaceStructure
CREATE TABLE arp_bln.surfacestructure (
  T_Id bigint PRIMARY KEY DEFAULT nextval('arp_bln.t_ili2db_seq')
  ,T_Seq bigint NULL
  ,multisurface_surfaces bigint NULL
)
;
SELECT AddGeometryColumn('arp_bln','surfacestructure','surface',(SELECT srid FROM SPATIAL_REF_SYS WHERE AUTH_NAME='EPSG' AND AUTH_SRID=2056),'POLYGON',2);
CREATE INDEX surfacestructure_surface_idx ON arp_bln.surfacestructure USING GIST ( surface );
CREATE INDEX surfacestructure_multisurface_surfaces_idx ON arp_bln.surfacestructure ( multisurface_surfaces );
COMMENT ON TABLE arp_bln.surfacestructure IS '@iliname GeometryCHLV95_V1.SurfaceStructure';
COMMENT ON COLUMN arp_bln.surfacestructure.surface IS '@iliname Surface';
COMMENT ON COLUMN arp_bln.surfacestructure.multisurface_surfaces IS '@iliname GeometryCHLV95_V1.MultiSurface.Surfaces';
-- GeometryCHLV95_V1.MultiSurface
CREATE TABLE arp_bln.multisurface (
  T_Id bigint PRIMARY KEY DEFAULT nextval('arp_bln.t_ili2db_seq')
  ,T_Seq bigint NULL
)
;
COMMENT ON TABLE arp_bln.multisurface IS '@iliname GeometryCHLV95_V1.MultiSurface';
-- SO_BLN_20170904.BLN.BLN
CREATE TABLE arp_bln.bln_bln (
  T_Id bigint PRIMARY KEY DEFAULT nextval('arp_bln.t_ili2db_seq')
  ,T_Ili_Tid uuid NULL DEFAULT uuid_generate_v4()
  ,objnummer varchar(20) NOT NULL
  ,aname varchar(255) NOT NULL
  ,refobjblatt varchar(1023) NULL
  ,inkraftsetzungsdatum date NOT NULL
  ,mutationsdatum date NULL
  ,mutationsgrund_text varchar(1024) NULL
)
;
SELECT AddGeometryColumn('arp_bln','bln_bln','geo_obj',(SELECT srid FROM SPATIAL_REF_SYS WHERE AUTH_NAME='EPSG' AND AUTH_SRID=2056),'MULTIPOLYGON',2);
CREATE INDEX bln_bln_geo_obj_idx ON arp_bln.bln_bln USING GIST ( geo_obj );
COMMENT ON TABLE arp_bln.bln_bln IS '@iliname SO_BLN_20170904.BLN.BLN';
COMMENT ON COLUMN arp_bln.bln_bln.objnummer IS 'Nummer des BLN-Objektes
@iliname ObjNummer';
COMMENT ON COLUMN arp_bln.bln_bln.aname IS 'Name des BLN-Objektes
@iliname Name';
COMMENT ON COLUMN arp_bln.bln_bln.refobjblatt IS 'Link auf das Objektblatt
@iliname RefObjBlatt';
COMMENT ON COLUMN arp_bln.bln_bln.inkraftsetzungsdatum IS 'Offizielles Datum der Inkraftsetzung
@iliname Inkraftsetzungsdatum';
COMMENT ON COLUMN arp_bln.bln_bln.mutationsdatum IS 'Datum einer VerÃ¤nderung des Objektes
@iliname Mutationsdatum';
COMMENT ON COLUMN arp_bln.bln_bln.mutationsgrund_text IS 'Grund der VerÃ¤nderung
@iliname Mutationsgrund_Text';
COMMENT ON COLUMN arp_bln.bln_bln.geo_obj IS 'Geometrie des BLN-Objektes
@iliname Geo_Obj';
CREATE TABLE arp_bln.T_ILI2DB_BASKET (
  T_Id bigint PRIMARY KEY
  ,dataset bigint NULL
  ,topic varchar(200) NOT NULL
  ,T_Ili_Tid varchar(200) NULL
  ,attachmentKey varchar(200) NOT NULL
)
;
CREATE INDEX T_ILI2DB_BASKET_dataset_idx ON arp_bln.t_ili2db_basket ( dataset );
CREATE TABLE arp_bln.T_ILI2DB_DATASET (
  T_Id bigint PRIMARY KEY
  ,datasetName varchar(200) NULL
)
;
CREATE TABLE arp_bln.T_ILI2DB_IMPORT (
  T_Id bigint PRIMARY KEY
  ,dataset bigint NOT NULL
  ,importDate timestamp NOT NULL
  ,importUser varchar(40) NOT NULL
  ,importFile varchar(200) NULL
)
;
CREATE INDEX T_ILI2DB_IMPORT_dataset_idx ON arp_bln.t_ili2db_import ( dataset );
COMMENT ON TABLE arp_bln.T_ILI2DB_IMPORT IS 'DEPRECATED, do not use';
CREATE TABLE arp_bln.T_ILI2DB_IMPORT_BASKET (
  T_Id bigint PRIMARY KEY
  ,import bigint NOT NULL
  ,basket bigint NOT NULL
  ,objectCount integer NULL
  ,start_t_id bigint NULL
  ,end_t_id bigint NULL
)
;
CREATE INDEX T_ILI2DB_IMPORT_BASKET_import_idx ON arp_bln.t_ili2db_import_basket ( import );
CREATE INDEX T_ILI2DB_IMPORT_BASKET_basket_idx ON arp_bln.t_ili2db_import_basket ( basket );
COMMENT ON TABLE arp_bln.T_ILI2DB_IMPORT_BASKET IS 'DEPRECATED, do not use';
CREATE TABLE arp_bln.T_ILI2DB_IMPORT_OBJECT (
  T_Id bigint PRIMARY KEY
  ,import_basket bigint NOT NULL
  ,class varchar(200) NOT NULL
  ,objectCount integer NULL
  ,start_t_id bigint NULL
  ,end_t_id bigint NULL
)
;
COMMENT ON TABLE arp_bln.T_ILI2DB_IMPORT_OBJECT IS 'DEPRECATED, do not use';
CREATE TABLE arp_bln.T_ILI2DB_INHERITANCE (
  thisClass varchar(1024) PRIMARY KEY
  ,baseClass varchar(1024) NULL
)
;
CREATE TABLE arp_bln.T_ILI2DB_SETTINGS (
  tag varchar(60) PRIMARY KEY
  ,setting varchar(255) NULL
)
;
CREATE TABLE arp_bln.T_ILI2DB_TRAFO (
  iliname varchar(1024) NOT NULL
  ,tag varchar(1024) NOT NULL
  ,setting varchar(1024) NOT NULL
)
;
CREATE TABLE arp_bln.T_ILI2DB_MODEL (
  file varchar(250) NOT NULL
  ,iliversion varchar(3) NOT NULL
  ,modelName text NOT NULL
  ,content text NOT NULL
  ,importDate timestamp NOT NULL
  ,PRIMARY KEY (modelName,iliversion)
)
;
CREATE TABLE arp_bln.T_ILI2DB_CLASSNAME (
  IliName varchar(1024) PRIMARY KEY
  ,SqlName varchar(1024) NOT NULL
)
;
CREATE TABLE arp_bln.T_ILI2DB_ATTRNAME (
  IliName varchar(1024) NOT NULL
  ,SqlName varchar(1024) NOT NULL
  ,Owner varchar(1024) NOT NULL
  ,Target varchar(1024) NULL
  ,PRIMARY KEY (SqlName,Owner)
)
;
CREATE TABLE arp_bln.T_ILI2DB_COLUMN_PROP (
  tablename varchar(255) NOT NULL
  ,subtype varchar(255) NULL
  ,columname varchar(255) NOT NULL
  ,tag varchar(1024) NOT NULL
  ,setting varchar(1024) NOT NULL
)
;
CREATE TABLE arp_bln.T_ILI2DB_TABLE_PROP (
  tablename varchar(255) NOT NULL
  ,tag varchar(1024) NOT NULL
  ,setting varchar(1024) NOT NULL
)
;
ALTER TABLE arp_bln.surfacestructure ADD CONSTRAINT surfacestructure_multisurface_surfaces_fkey FOREIGN KEY ( multisurface_surfaces ) REFERENCES arp_bln.multisurface DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE arp_bln.T_ILI2DB_BASKET ADD CONSTRAINT T_ILI2DB_BASKET_dataset_fkey FOREIGN KEY ( dataset ) REFERENCES arp_bln.T_ILI2DB_DATASET DEFERRABLE INITIALLY DEFERRED;
CREATE UNIQUE INDEX T_ILI2DB_DATASET_datasetName_key ON arp_bln.T_ILI2DB_DATASET (datasetName)
;
ALTER TABLE arp_bln.T_ILI2DB_IMPORT_BASKET ADD CONSTRAINT T_ILI2DB_IMPORT_BASKET_import_fkey FOREIGN KEY ( import ) REFERENCES arp_bln.T_ILI2DB_IMPORT DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE arp_bln.T_ILI2DB_IMPORT_BASKET ADD CONSTRAINT T_ILI2DB_IMPORT_BASKET_basket_fkey FOREIGN KEY ( basket ) REFERENCES arp_bln.T_ILI2DB_BASKET DEFERRABLE INITIALLY DEFERRED;
CREATE UNIQUE INDEX T_ILI2DB_MODEL_modelName_iliversion_key ON arp_bln.T_ILI2DB_MODEL (modelName,iliversion)
;
CREATE UNIQUE INDEX T_ILI2DB_ATTRNAME_SqlName_Owner_key ON arp_bln.T_ILI2DB_ATTRNAME (SqlName,Owner)
;
