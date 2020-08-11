CREATE INDEX   taxonames_idx ON taxa     USING GIN(taxonname gin_trgm_ops);
CREATE INDEX   sitenames_idx ON sites    USING GIN(sitename gin_trgm_ops);
CREATE INDEX familynames_idx ON contacts USING GIN(familyname gin_trgm_ops);

CREATE INDEX sitegeog_gix ON sites USING GIST (geog);

CREATE INDEX youngage_idx ON chronologies USING btree(ageboundyounger);

CREATE INDEX oldage_idx ON chronologies USING btree(ageboundolder);
CREATE INDEX youngage_idx ON chronologies USING btree(ageboundyounger);

CREATE INDEX oldage_idx ON chroncontrols USING btree(agelimitolder);
CREATE INDEX youngage_idx ON chroncontrols USING btree(agelimityounger);

CREATE INDEX smpage_idx ON sampleages USING btree(age);
CREATE INDEX smpageold_idx ON sampleages USING btree(ageolder);
CREATE INDEX smpageyoung_idx ON sampleages USING btree(ageyounger);

CREATE INDEX chronage_idx ON chroncontrols USING btree(age);
CREATE INDEX geoage_idx ON geochronology USING btree(age);
