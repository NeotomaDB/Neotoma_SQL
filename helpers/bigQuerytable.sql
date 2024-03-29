CREATE TABLE ap.querytable WITH (autovacuum_enabled = false) AS (
WITH allids AS (
        SELECT st.siteid,
        unnest(array_append(gp.geoout, gp.geoin::int)) AS geopol
        FROM ndb.sites AS st
        INNER JOIN ndb.sitegeopolitical AS sgp ON st.siteid = sgp.siteid
        INNER JOIN ndb.geopoliticalunits AS gpu ON gpu.geopoliticalid = sgp.geopoliticalid
        INNER JOIN ndb.geopaths AS gp ON gp.geoin = sgp.geopoliticalid
    ),
    sgp AS (
        SELECT siteid, array_agg(DISTINCT geopol) AS geopol
        FROM allids
        GROUP BY siteid
    )
    SELECT st.siteid,
        st.sitename,
        ds.datasetid,
        chron.chronologyid,
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
        array_remove(array_agg(DISTINCT dspb.publicationid), NULL) AS publications,
        array_remove(array_agg(DISTINCT var.taxonid), NULL) AS taxa,
        array_remove(array_agg(DISTINCT smpkw.keywordid), NULL) AS keywords,
        array_remove(array_agg(DISTINCT dpi.contactid) || array_agg(DISTINCT sma.contactid), NULL) AS contacts,
        jsonb_build_object('collectionunitid', cu.collectionunitid,
							 'collectionunit', cu.collunitname,
									 'handle', cu.handle,
						 'collectionunittype', cut.colltype,
								   'datasets', json_agg(DISTINCT jsonb_build_object('datasetid', ds.datasetid,
                                                                        'datasettype', dst.datasettype))) AS collectionunit,
        sgp.geopol
    FROM ndb.sites AS st
    INNER JOIN ndb.collectionunits AS cu ON cu.siteid = st.siteid
    LEFT OUTER JOIN ndb.collectiontypes AS cut ON cut.colltypeid = cu.colltypeid
    INNER JOIN ndb.datasets AS ds ON ds.collectionunitid = cu.collectionunitid
    LEFT OUTER JOIN ndb.depenvttypes AS dvt ON dvt.depenvtid = cu.depenvtid
    LEFT OUTER JOIN ndb.datasetpis AS dpi ON dpi.datasetid = ds.datasetid
    INNER JOIN ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
    INNER JOIN ndb.datasetdatabases AS dsdb ON ds.datasetid = dsdb.datasetid
    LEFT OUTER JOIN ndb.datasetpublications AS dspb ON dspb.datasetid = ds.datasetid
    LEFT OUTER JOIN ndb.chronologies AS chron ON chron.collectionunitid = ds.collectionunitid
    LEFT OUTER JOIN ndb.dsageranges AS arg ON ds.datasetid = arg.datasetid AND chron.agetypeid = arg.agetypeid
    LEFT OUTER JOIN ndb.agetypes  AS agetypes ON agetypes.agetypeid = arg.agetypeid
    INNER JOIN ndb.samples AS smp ON smp.datasetid = ds.datasetid 
    LEFT OUTER JOIN ndb.sampleanalysts AS sma ON sma.sampleid = smp.sampleid
    LEFT OUTER JOIN ndb.samplekeywords AS smpkw ON smpkw.sampleid = smp.sampleid
    LEFT OUTER JOIN ndb.data AS dt ON dt.sampleid = smp.sampleid
    LEFT OUTER JOIN ndb.variables AS var ON var.variableid = dt.variableid
    INNER JOIN sgp AS sgp ON st.siteid = sgp.siteid
    GROUP BY st.siteid,
        cu.collectionunitid,
        st.sitename,
        ds.datasetid,
        cut.colltype,
        chron.chronologyid,
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

CREATE UNIQUE INDEX distinctrows ON ap.querytable(datasetid, chronologyid);
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
CREATE INDEX publicationidindex ON ap.querytable USING GIN(publications gin__int_ops);
CREATE INDEX geoidindex ON ap.querytable USING GIN(geopol gin__int_ops);
CREATE INDEX olderidx ON ap.querytable(older);
CREATE INDEX youngeridx ON ap.querytable(younger);

INSERT INTO ap.querytable
WITH allids AS (
        SELECT st.siteid,
        unnest(array_append(gp.geoout, gp.geoin::int)) AS geopol
        FROM ndb.sites AS st
        INNER JOIN ndb.sitegeopolitical AS sgp ON st.siteid = sgp.siteid
        INNER JOIN ndb.geopoliticalunits AS gpu ON gpu.geopoliticalid = sgp.geopoliticalid
        INNER JOIN ndb.geopaths AS gp ON gp.geoin = sgp.geopoliticalid
    ),
    sgp AS (
        SELECT siteid, array_agg(DISTINCT geopol) AS geopol
        FROM allids
        GROUP BY siteid
    )
    SELECT st.siteid,
        st.sitename,
        ds.datasetid,
        chron.chronologyid,
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
        array_remove(array_agg(DISTINCT dspb.publicationid), NULL) AS publications,
        array_remove(array_agg(DISTINCT var.taxonid), NULL) AS taxa,
        array_remove(array_agg(DISTINCT smpkw.keywordid), NULL) AS keywords,
        array_remove(array_agg(DISTINCT dpi.contactid) || array_agg(DISTINCT sma.contactid), NULL) AS contacts,
        jsonb_build_object('collectionunitid', cu.collectionunitid,
							 'collectionunit', cu.collunitname,
									 'handle', cu.handle,
						 'collectionunittype', cut.colltype,
								   'datasets', json_agg(DISTINCT jsonb_build_object('datasetid', ds.datasetid,
                                                                        'datasettype', dst.datasettype))) AS collectionunit,
        sgp.geopol
    FROM ndb.sites AS st
    INNER JOIN ndb.collectionunits AS cu ON cu.siteid = st.siteid
    LEFT OUTER JOIN ndb.collectiontypes AS cut ON cut.colltypeid = cu.colltypeid
    INNER JOIN ndb.datasets AS ds ON ds.collectionunitid = cu.collectionunitid
    LEFT OUTER JOIN ndb.depenvttypes AS dvt ON dvt.depenvtid = cu.depenvtid
    LEFT OUTER JOIN ndb.datasetpis AS dpi ON dpi.datasetid = ds.datasetid
    INNER JOIN ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
    INNER JOIN ndb.datasetdatabases AS dsdb ON ds.datasetid = dsdb.datasetid
    LEFT OUTER JOIN ndb.datasetpublications AS dspb ON dspb.datasetid = ds.datasetid
    LEFT OUTER JOIN ndb.chronologies AS chron ON chron.collectionunitid = ds.collectionunitid
    LEFT OUTER JOIN ndb.dsageranges AS arg ON ds.datasetid = arg.datasetid AND chron.agetypeid = arg.agetypeid
    LEFT OUTER JOIN ndb.agetypes  AS agetypes ON agetypes.agetypeid = arg.agetypeid
    INNER JOIN ndb.samples AS smp ON smp.datasetid = ds.datasetid 
    LEFT OUTER JOIN ndb.sampleanalysts AS sma ON sma.sampleid = smp.sampleid
    LEFT OUTER JOIN ndb.samplekeywords AS smpkw ON smpkw.sampleid = smp.sampleid
    LEFT OUTER JOIN ndb.data AS dt ON dt.sampleid = smp.sampleid
    LEFT OUTER JOIN ndb.variables AS var ON var.variableid = dt.variableid
    INNER JOIN sgp AS sgp ON st.siteid = sgp.siteid
    WHERE ds.recdatemodified > current_date - interval '2' day OR
          smp.recdatemodified > current_date - interval '2' day
    GROUP BY st.siteid,
        cu.collectionunitid,
        st.sitename,
        ds.datasetid,
        cut.colltype,
        chron.chronologyid,
        dsdb.databaseid,
        st.altitude,
        dst.datasettype,
        st.geog,
        arg.older,
        arg.younger,
        agetypes.agetype,
        sgp.geopol,
        dvt.depenvt
ON CONFLICT (datasetid, chronologyid) DO UPDATE
   SET siteid = EXCLUDED.siteid,
       sitename = EXCLUDED.sitename,
       datasetid = EXCLUDED.datasetid,
       chronologyid = EXCLUDED.chronologyid,
       altitude = EXCLUDED.altitude,
       datasettype = EXCLUDED.datasettype,
       databaseid = EXCLUDED.databaseid,
       collectionunitid = EXCLUDED.collectionunitid,
       colltype = EXCLUDED.colltype,
       depenvt = EXCLUDED.depenvt,
       geog = EXCLUDED.geog,
       older = EXCLUDED.older,
       younger = EXCLUDED.younger,
       agetype = EXCLUDED.agetype,
       taxa = EXCLUDED.taxa,
       keywords = EXCLUDED.keywords,
       contacts = EXCLUDED.contacts,
       collectionunit = EXCLUDED.collectionunit,
       publications = EXCLUDED.publications,
       geopol = EXCLUDED.geopol;

REASSIGN OWNED BY sug335 TO functionwriter;
GRANT SELECT ON ap.querytable TO neotomawsreader;
