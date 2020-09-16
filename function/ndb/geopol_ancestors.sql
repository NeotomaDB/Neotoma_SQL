CREATE TABLE ndb.geopaths (
  geoout INTEGER[] NOT NULL,
  geoin BIGINT NOT NULL,
  PRIMARY KEY (geoout, geoin),
  FOREIGN KEY (geoin) REFERENCES ndb.geopoliticalunits(geopoliticalid)
);

INSERT INTO ndb.geopaths(geoout, geoin)
  WITH RECURSIVE geopol AS (
  	  SELECT gp.geopoliticalid, ARRAY[]::integer[] AS ancestors
        FROM ndb.geopoliticalunits AS gp
  	  WHERE gp.highergeopoliticalid = 0
    UNION ALL
  	  SELECT gp.geopoliticalid, geopol.ancestors || gp.highergeopoliticalid
  	  FROM ndb.geopoliticalunits AS gp, geopol
  	  WHERE gp.highergeopoliticalid = geopol.geopoliticalid)
  SELECT geo.ancestors AS geoout,
  	   geo.geopoliticalid AS geoin
  FROM geopol AS geo
