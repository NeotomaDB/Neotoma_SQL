CREATE INDEX IF NOT EXISTS   taxonames_idx ON ndb.taxa     USING GIN(taxonname gin_trgm_ops);
CREATE INDEX IF NOT EXISTS   sitenames_idx ON ndb.sites    USING GIN(sitename gin_trgm_ops);
CREATE INDEX IF NOT EXISTS familynames_idx ON ndb.contacts USING GIN(familyname gin_trgm_ops);

CREATE INDEX IF NOT EXISTS    sitegeog_gix ON ndb.sites       USING GIST (geog);

CREATE INDEX IF NOT EXISTS chryoungage_idx ON ndb.chronologies USING btree(ageboundyounger);
CREATE INDEX IF NOT EXISTS   chroldage_idx ON ndb.chronologies USING btree(ageboundolder);

CREATE INDEX IF NOT EXISTS ccrchronage_idx ON ndb.chroncontrols USING btree(age);
CREATE INDEX IF NOT EXISTS   ccroldage_idx ON ndb.chroncontrols USING btree(agelimitolder);
CREATE INDEX IF NOT EXISTS ccryoungage_idx ON ndb.chroncontrols USING btree(agelimityounger);

CREATE INDEX IF NOT EXISTS      smpage_idx ON ndb.sampleages USING btree(age);
CREATE INDEX IF NOT EXISTS   smpageold_idx ON ndb.sampleages USING btree(ageolder);
CREATE INDEX IF NOT EXISTS smpageyoung_idx ON ndb.sampleages USING btree(ageyounger);

CREATE INDEX IF NOT EXISTS      geoage_idx ON ndb.geochronology USING btree(age);

CREATE INDEX IF NOT EXISTS      variableel ON ndb.variables USING btree(taxonid, variableelementid, variableunitsid);
