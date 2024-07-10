WITH cesium AS (INSERT INTO ndb.taxa(taxoncode, taxonname, highertaxonid, extinct, taxagroupid, validatorid) VALUES ('Cs', 'Cesium', 23801, FALSE, 'CHM', 5126) RETURNING taxonid),
bismuth AS (INSERT INTO ndb.taxa(taxoncode, taxonname, highertaxonid, extinct, taxagroupid, validatorid) VALUES ('Bi', 'Bismuth', 23801, FALSE, 'CHM', 5126) RETURNING taxonid)
INSERT INTO ndb.taxa(taxoncode, taxonname, highertaxonid, extinct, taxagroupid, validatorid)
VALUES
('dm.cumu','cumulative dry mass', 35449, FALSE, 'LAB', 5126),
('210Pb/210Po','210Pb/210Po', 24854, FALSE, 'CHM', 5126),
('210Pb','210Pb', 24854, FALSE, 'CHM', 5126),
('214Pb','214Pb', 24854, FALSE, 'CHM', 5126),
('214Bi','214Bi', (SELECT taxonid FROM bismuth), FALSE, 'CHM', 5126),
('137Cs','137Cs', (SELECT taxonid FROM cesium), FALSE, 'CHM', 5126),
('dm.acc.rate','dry mass accumulation rate', 35449, FALSE, 'LAB', 5126);
