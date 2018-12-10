CREATE OR REPLACE FUNCTION ti.getsites(
  _datasettypeid      INTEGER = null,
  _sitename CHARACTER VARYING = null,
  _geopoliticalid     INTEGER = null,
  _contactid          INTEGER = null,
  _authorid           INTEGER = null)
RETURNS TABLE (
  siteid   INTEGER,
  sitename CHARACTER VARYING,
  geog     CHARACTER VARYING
)
LANGUAGE sql
AS $function$

SELECT st.siteid, st.sitename, ST_AsText(st.geog)
from   ndb.sites               AS st
  JOIN ndb.dslinks             AS dsl  ON        dsl.siteid = st.siteid
  JOIN ndb.sitegeopolitical    AS sgp  ON        sgp.siteid = st.siteid
  JOIN ndb.datasets            AS ds   ON      ds.datasetid = dsl.datasetid
  JOIN ndb.datasetpis          AS dspi ON      ds.datasetid = dspi.datasetid
  JOIN ndb.datasetpublications AS dsp  ON     dsl.datasetid = dsp.datasetid
  JOIN ndb.publications        AS pub  ON dsp.publicationid = pub.publicationid
  JOIN ndb.publicationauthors  AS pua  ON pub.publicationid = pua.publicationid
  WHERE
  (_sitename       IS NULL OR LOWER(_sitename) LIKE LOWER(st.sitename)) AND
  (_datasettypeid  IS NULL OR ds.datasettypeid = _datasettypeid)        AND
  (_geopoliticalid IS NULL OR sgp.geopoliticalid = _geopoliticalid)     AND
  (_contactid      IS NULL OR dspi.contactid = _contactid)              AND
  (_authorid       IS NULL OR  pua.contactid = _authorid)
GROUP BY st.siteid, st.sitename, st.geog
$function$
