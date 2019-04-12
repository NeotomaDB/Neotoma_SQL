CREATE OR REPLACE  FUNCTION doi.datasetchanged()
RETURNS TABLE(datasetid integer,
              dataset timestamp,
              dspi timestamp,
              contact timestamp,
              collunit timestamp,
              sites timestamp,
              datatype timestamp,
              ds_sub timestamp,
              datapub timestamp,
              chron timestamp,
              pub timestamp)
LANGUAGE 'sql'

COST 100
VOLATILE
AS $BODY$
  SELECT       ds.datasetid,
          MAX(ds.recdatemodified) AS dataset,
        MAX(dspi.recdatemodified) AS dspi,
         MAX(cts.recdatemodified) AS contact,
          MAX(cu.recdatemodified) AS collunit,
         MAX(sts.recdatemodified) AS sites,
         MAX(dst.recdatemodified) AS datatype,
         MAX(dss.recdatemodified) AS ds_sub,
         MAX(dsp.recdatemodified) AS datapub,
         MAX(chr.recdatemodified) AS chron,
  	     MAX(pub.recdatemodified) AS pub
  FROM
    ndb.datasets AS ds
    LEFT JOIN          ndb.datasetpis AS dspi ON ds.datasetid = dspi.datasetid
    LEFT JOIN            ndb.contacts AS cts  ON dspi.contactid = cts.contactid
    INNER JOIN    ndb.collectionunits AS cu   ON ds.collectionunitid = cu.collectionunitid
    INNER JOIN              ndb.sites AS sts  ON cu.siteid = sts.siteid
    INNER JOIN       ndb.datasettypes AS dst  ON ds.datasettypeid = dst.datasettypeid
    INNER JOIN ndb.datasetsubmissions AS dss  ON dss.datasetid = ds.datasetid
    LEFT JOIN ndb.datasetpublications AS dsp  ON dsp.datasetid = ds.datasetid
    LEFT JOIN        ndb.chronologies AS chr  ON chr.collectionunitid = cu.collectionunitid
    LEFT JOIN        ndb.publications AS pub  ON dsp.publicationid = pub.publicationid
    LEFT JOIN             ndb.samples AS smp  ON smp.datasetid = ds.datasetid
    LEFT JOIN                ndb.data AS dt   ON dt.sampleid = smp.sampleid
    LEFT JOIN ndb.variables AS var ON var.variableid = dt.variableid
    LEFT JOIN ndb.datasetdoi AS doi ON doi.datasetid = ds.datasetid
    GROUP BY ds.datasetid
    ORDER BY pub DESC
$BODY$
