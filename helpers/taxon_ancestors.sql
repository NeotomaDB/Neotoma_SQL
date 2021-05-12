CREATE TABLE ndb.taxonpaths (
  taxonout INTEGER[] NOT NULL,
  taxonid BIGINT NOT NULL,
  PRIMARY KEY (taxonout, taxonid),
  FOREIGN KEY (taxonid) REFERENCES ndb.taxa(taxonid)
);

INSERT INTO ndb.taxonpaths(taxonout, taxonid)

WITH RECURSIVE taxon AS (
	  SELECT tx.taxonid, ARRAY[]::integer[] AS ancestors
      FROM ndb.taxa AS tx
	  WHERE tx.highertaxonid = tx.taxonid
  UNION ALL
	  SELECT tx.taxonid, taxon.ancestors || gp.highertaxonid
	  FROM ndb.taxa AS tx, taxon
	  WHERE tx.highertaxonid = taxon.taxonid)

SELECT taxon.ancestors AS taxonout,
	   taxon.taxonid AS taxonin
FROM taxon AS taxon;