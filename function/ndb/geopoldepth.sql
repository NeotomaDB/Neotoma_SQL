CREATE OR REPLACE VIEW ndb.geopoldepth AS
WITH RECURSIVE gpid_path AS (
SELECT gp.geopoliticalid, gp.geopoliticalid::text AS gpid
FROM
	ndb.geopoliticalunits AS gp
	WHERE gp.rank = 1
UNION ALL
	SELECT gpu.geopoliticalid, CONCAT(gpa.gpid, ',', gpu.geopoliticalid) FROM
	ndb.geopoliticalunits AS gpu
	INNER JOIN gpid_path AS gpa ON gpa.geopoliticalid::int = gpu.highergeopoliticalid::int
)
SELECT gp.geopoliticalid,
        gpu.geopoliticalname,
		gpu.geopoliticalunit,
		gpu.rank,
		string_to_array(gp.gpid, ',')::int[] AS path
FROM gpid_path AS gp
JOIN ndb.geopoliticalunits AS gpu ON gpu.geopoliticalid = gp.geopoliticalid
ORDER BY gp.geopoliticalid
