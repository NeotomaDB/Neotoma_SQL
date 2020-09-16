CREATE TABLE IF NOT EXISTS ndb.geopaths (
  geoout INTEGER[] NOT NULL,
  geoin BIGINT NOT NULL,
  PRIMARY KEY (geoout, geoin),
  FOREIGN KEY (geoin) REFERENCES ndb.geopoliticalunits(geopoliticalid)
);

GRANT SELECT ON ndb.geopaths TO neotomawsreader;
GRANT SELECT ON ndb.geopaths TO neotomawswriter;

INSERT INTO ndb.geopaths(geoout, geoin)
  WITH RECURSIVE geopol AS (
    SELECT gp.geopoliticalid, ARRAY[]::integer[] AS ancestors
      FROM ndb.geopoliticalunits AS gp
        LEFT OUTER JOIN ndb.geopaths AS geop ON geop.geoin = gp.geopoliticalid
      WHERE gp.highergeopoliticalid = 0 AND geop.geoin IS NULL
    UNION ALL
  	  SELECT gp.geopoliticalid, geopol.ancestors || gp.highergeopoliticalid
  	  FROM ndb.geopoliticalunits AS gp, geopol
  	  WHERE gp.highergeopoliticalid = geopol.geopoliticalid)
  SELECT geo.ancestors AS geoout,
  	   geo.geopoliticalid AS geoin
  FROM geopol AS geo;
