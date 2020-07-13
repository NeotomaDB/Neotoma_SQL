CREATE OR REPLACE FUNCTION ti.getsites(_datasettypeid integer DEFAULT NULL::integer, _sitename character varying DEFAULT NULL::character varying, _geopoliticalid integer DEFAULT NULL::integer, _contactid integer DEFAULT NULL::integer, _authorid integer DEFAULT NULL::integer)
 RETURNS TABLE(  siteid integer,
               sitename character varying,
                   geog character varying,
            geopolname1 character varying,
            geopolname2 character varying)
 LANGUAGE sql
AS $function$
WITH goodgeo AS (
  SELECT geoout || geoin::integer AS geoarray, geoin FROM ndb.geopaths
)

SELECT st.siteid,
       st.sitename,
       ST_AsText(st.geog),
       gpa.geopolname1,
       gpb.geopolname2
FROM   ndb.sites                    AS st
  LEFT JOIN ndb.dslinks                  AS dsl  ON        dsl.siteid = st.siteid
  LEFT JOIN ndb.sitegeopolitical         AS sgp  ON        sgp.siteid = st.siteid
  LEFT JOIN ndb.datasets                 AS ds   ON      ds.datasetid = dsl.datasetid
  LEFT JOIN ndb.datasetpis          AS dspi ON      ds.datasetid = dspi.datasetid
  LEFT JOIN ndb.datasetpublications AS dsp  ON     dsl.datasetid = dsp.datasetid
  LEFT JOIN ndb.publications        AS pub  ON dsp.publicationid = pub.publicationid
  LEFT JOIN ndb.publicationauthors  AS pua  ON pub.publicationid = pua.publicationid
  LEFT JOIN goodgeo AS gg ON gg.geoin = sgp.geopoliticalid
  LEFT JOIN ti.geopol1                   AS gpa  ON        gpa.siteid = st.siteid
  LEFT JOIN ti.geopol2                   AS gpb  ON        gpb.siteid = st.siteid
  WHERE
  (_sitename       IS NULL OR LOWER(st.sitename) LIKE LOWER(_sitename)) AND
  (_datasettypeid  IS NULL OR   ds.datasettypeid = _datasettypeid)        AND
  (_geopoliticalid IS NULL OR _geopoliticalid = ANY(gg.geoarray))     AND
  (_contactid      IS NULL OR     dspi.contactid = _contactid)              AND
  (_authorid       IS NULL OR      pua.contactid = _authorid)
GROUP BY st.siteid, st.sitename, st.geog, gpa.geopolname1, gpb.geopolname2
$function$
