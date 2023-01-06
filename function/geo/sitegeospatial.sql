CREATE INDEX gadm_geom_idx
  ON gadm404
  USING GIST (geom);

CREATE MATERIALIZED VIEW IF NOT EXISTS public.geositename AS
SELECT st.siteid,
       st.sitename,
       uid,
       name_0,
       name_1,
       name_2,
       name_3,
       name_4,
       concat_ws(' ', name_0, varname_0, name_1, varname_1,
       nl_name_1, name_2, varname_2, nl_name_2, name_3,
       varname_3, nl_name_3, name_4, varname_4, name_5) AS names,
       array_agg(ds.datasetid)
FROM ndb.sites AS st
LEFT OUTER JOIN gadm404 ON ST_Intersects(st.geog::geometry, gadm404.geom)
LEFT JOIN ndb.collectionunits AS cu ON cu.siteid = st.siteid
LEFT JOIN ndb.datasets AS ds on ds.collectionunitid = cu.collectionunitid
GROUP BY st.siteid, st.sitename, uid, name_0, name_1, name_2, name_3, name_4, name_5,
         varname_0, varname_1, varname_2, varname_3, varname_4,
         nl_name_1, nl_name_2, nl_name_3;

CREATE INDEX pglocation_idx ON geositename USING GIN (to_tsvector('english', names));