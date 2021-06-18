DELETE FROM ndb.elementdatasettaxagroups AS edtg
WHERE edtg.taxagroupid NOT IN (SELECT taxagroupid FROM ndb.taxagrouptypes);
ALTER TABLE ndb.elementdatasettaxagroups
ADD CONSTRAINT 	edt_group FOREIGN KEY (taxagroupid) REFERENCES taxagrouptypes(taxagroupid);

DELETE FROM ndb.elementdatasettaxagroups AS edtg
WHERE edtg.elementtypeid NOT IN (SELECT elementtypeid FROM ndb.elementtypes);
ALTER TABLE ndb.elementdatasettaxagroups
ADD CONSTRAINT edt_types FOREIGN KEY (elementtypeid) REFERENCES elementtypes (elementtypeid);

DELETE FROM ndb.eventchronology AS ec
WHERE ec.analysisunitid NOT IN (SELECT analysisunitid FROM ndb.analysisunits);
ALTER TABLE ndb.eventchronology
ADD CONSTRAINT 	evc_alu FOREIGN KEY (analysisunitid) REFERENCES analysisunits (analysisunitid);

DELETE FROM ndb.eventchronology AS ec
WHERE ec.eventid NOT IN (SELECT eventid FROM ndb.events);
ALTER TABLE ndb.eventchronology
ADD CONSTRAINT 	evc_evt FOREIGN KEY (eventid) REFERENCES events (eventid);

DELETE FROM ndb.eventchronology AS ech
WHERE ech.chroncontrolid NOT IN (SELECT chroncontrolid FROM ndb.chroncontrols);
ALTER TABLE ndb.eventchronology
ADD CONSTRAINT 	evc_ccid FOREIGN KEY (chroncontrolid) REFERENCES chroncontrols (chroncontrolid);

DELETE FROM ndb.eventtypes AS ety
WHERE ety.chroncontroltypeid NOT IN (SELECT chroncontroltypeid FROM ndb.chroncontroltypes);
ALTER TABLE ndb.eventtypes
ADD CONSTRAINT 	evt_cct FOREIGN KEY (chroncontroltypeid) REFERENCES chroncontroltypes (chroncontroltypeid);

DELETE FROM ndb.publications AS pub
WHERE pub.pubtypeid NOT IN (SELECT pubtypeid FROM ndb.publicationtypes);
ALTER TABLE ndb.publications
ADD CONSTRAINT 	pub_pty FOREIGN KEY (pubtypeid) REFERENCES publicationtypes (pubtypeid);

DELETE FROM ndb.relativechronology AS rc
WHERE rc.chroncontrolid NOT IN (SELECT chroncontrolid FROM ndb.chroncontrols);
ALTER TABLE ndb.relativechronology
ADD CONSTRAINT 	 rc_ccid	FOREIGN KEY (chroncontrolid) REFERENCES chroncontrols (chroncontrolid);

DELETE FROM ndb.specimendates AS sd
WHERE sd.geochronid NOT IN (SELECT geochronid FROM ndb.geochronology);
ALTER TABLE ndb.specimendates
ADD CONSTRAINT 	 sd_gcid	FOREIGN KEY (geochronid) REFERENCES geochronology (geochronid);

DELETE FROM ndb.specimendates AS sd
WHERE sd.taxonid NOT IN (SELECT taxonid FROM ndb.taxa);
ALTER TABLE ndb.specimendates
ADD CONSTRAINT 	 	sd_txid FOREIGN KEY (taxonid) REFERENCES taxa (taxonid);

DELETE FROM ndb.specimendates AS sd
WHERE sd.fractionid NOT IN (SELECT fractionid FROM ndb.fractiondated);
ALTER TABLE ndb.specimendates
ADD CONSTRAINT 	 sd_fcid	FOREIGN KEY (fractionid) REFERENCES fractiondated (fractionid);

DELETE FROM ndb.specimendates AS sd
WHERE sd.sampleid NOT IN (SELECT sampleid FROM ndb.samples);
ALTER TABLE ndb.specimendates
ADD CONSTRAINT 	 sd_smpid	FOREIGN KEY (sampleid) REFERENCES samples (sampleid);

DELETE FROM ndb.specimendates AS sd
WHERE sd.elementtypeid NOT IN (SELECT elementtypeid FROM ndb.elementtypes);
ALTER TABLE ndb.specimendates
ADD CONSTRAINT 	 sd_etyid	FOREIGN KEY (elementtypeid) REFERENCES elementtypes (elementtypeid);
