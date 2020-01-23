CREATE INDEX taxonname_btree ON ndb.taxa USING btree (taxonname)
CREATE INDEX sitegeog_gix ON sites USING GIST (geog);
CREATE INDEX youngage_idx ON chronologies USING btree(ageboundyounger)
CREATE INDEX oldage_idx ON chronologies USING btree(ageboundolder)
