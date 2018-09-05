CREATE MATERIALIZED VIEW ti.longgeonames AS
  WITH RECURSIVE gpid AS (
    SELECT
  				  gpu.geopoliticalid AS child,
  			gpu.highergeopoliticalid AS parent,
  				gpu.geopoliticalname,
  	CONCAT(gpu.geopoliticalname, '') AS place,
  	1 AS depth_level
    FROM         ndb.geopoliticalunits AS gpu
  	UNION ALL
  SELECT
  	gpu.geopoliticalid AS child,
  	gpu.highergeopoliticalid AS parent,
  	gpu.geopoliticalname,
  	CONCAT(gpu.geopoliticalname, ', ', hgpu.place) AS place,
  	hgpu.depth_level + 1
  	FROM gpid AS hgpu
  	INNER JOIN ndb.geopoliticalunits AS gpu ON hgpu.child = gpu.highergeopoliticalid)

  SELECT child AS geopoliticalid, geopoliticalname, place AS long_name
  FROM gpid AS main
  WHERE main.depth_level = (SELECT max(ml.depth_level) FROM gpid AS ml WHERE ml.child = main.child);

WITH data
