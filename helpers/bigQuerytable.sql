DROP MATERIALIZED VIEW ap.querytable CASCADE;
CREATE MATERIALIZED VIEW ap.querytable AS (
    WITH sgp AS (
        SELECT st.siteid,
        array_append(gp.geoout, gp.geoin::int) AS geopol,
        rank() OVER (partition by st.siteid order by st.siteid, array_length(gp.geoout,1) ASC) AS rank
        FROM ndb.sites AS st
        INNER JOIN ndb.sitegeopolitical AS sgp ON st.siteid = sgp.siteid
        INNER JOIN ndb.geopoliticalunits AS gpu ON gpu.geopoliticalid = sgp.geopoliticalid
        INNER JOIN ndb.geopaths AS gp ON gp.geoin = sgp.geopoliticalid
    )
    SELECT st.siteid,
        st.sitename,
        ds.datasetid,
        st.altitude,
        dst.datasettype,
        dsdb.databaseid,
        cu.collectionunitid,
        cut.colltype,
        dvt.depenvt,
        st.geog,
        arg.older,
        arg.younger,
        agetypes.agetype,
        array_agg(DISTINCT var.taxonid) AS taxa,
        array_agg(DISTINCT smpkw.keywordid) AS keywords,
        array_agg(DISTINCT dpi.contactid) AS contacts,
        sgp.geopol
    FROM ndb.sites AS st
    INNER JOIN ndb.collectionunits AS cu ON cu.siteid = st.siteid
    INNER JOIN ndb.collectiontypes AS cut ON cut.colltypeid = cu.colltypeid
    INNER JOIN ndb.datasets AS ds ON ds.collectionunitid = cu.collectionunitid
    INNER JOIN ndb.depenvttypes AS dvt ON dvt.depenvtid = cu.depenvtid
    INNER JOIN ndb.datasetpis AS dpi ON dpi.datasetid = ds.datasetid
    INNER JOIN ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
    INNER JOIN ndb.datasetdatabases AS dsdb ON ds.datasetid = dsdb.datasetid
    LEFT OUTER JOIN ndb.dsageranges AS arg ON ds.datasetid = arg.datasetid
    LEFT OUTER JOIN ndb.agetypes  AS agetypes ON agetypes.agetypeid = arg.agetypeid
    INNER JOIN ndb.samples AS smp ON smp.datasetid = ds.datasetid 
    LEFT OUTER JOIN ndb.samplekeywords AS smpkw ON smpkw.sampleid = smp.sampleid
    INNER JOIN ndb.data AS dt ON dt.sampleid = smp.sampleid
    INNER JOIN ndb.variables AS var ON var.variableid = dt.variableid
    INNER JOIN sgp AS sgp ON st.siteid = sgp.siteid
    WHERE sgp.rank = 1
    GROUP BY st.siteid,
        cu.collectionunitid,
        st.sitename,
        ds.datasetid,
        cut.colltype,
        dsdb.databaseid,
        st.altitude,
        dst.datasettype,
        st.geog,
        arg.older,
        arg.younger,
        agetypes.agetype,
        sgp.geopol,
        dvt.depenvt
);

CREATE INDEX spatialgeom ON ap.querytable USING GIST(geog);
CREATE INDEX dstindex ON ap.querytable(datasettype);
CREATE INDEX depenvindex ON ap.querytable(depenvt);
CREATE INDEX atyindex ON ap.querytable(agetype);
CREATE INDEX siteidindex ON ap.querytable(siteid);
CREATE INDEX sitename ON ap.querytable USING GIST (sitename gist_trgm_ops);
CREATE INDEX datasetidindex ON ap.querytable(datasetid);
CREATE INDEX altitudeidx ON ap.querytable(altitude);
CREATE INDEX taxonidindex ON ap.querytable USING GIN(taxa gin__int_ops);
CREATE INDEX contactidindex ON ap.querytable USING GIN(contacts gin__int_ops);
CREATE INDEX keywordidindex ON ap.querytable USING GIN(keywords gin__int_ops);
CREATE INDEX geoidindex ON ap.querytable USING GIN(geopol gin__int_ops);
CREATE INDEX olderidx ON ap.querytable(older);
CREATE INDEX youngeridx ON ap.querytable(younger);

CREATE OR REPLACE FUNCTION ap.updatequery()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
BEGIN
REFRESH MATERIALIZED VIEW CONCURRENTLY ap.querytable;
RETURN NULL;
END $$;

CREATE TRIGGER updatewidequeryst
AFTER INSERT OR DELETE
ON ndb.sites
FOR EACH STATEMENT
EXECUTE PROCEDURE ap.updategpsites();

CREATE TRIGGER updatewidequeryds
AFTER INSERT OR DELETE
ON ndb.datasets
FOR EACH STATEMENT
EXECUTE PROCEDURE ap.updategpsites();