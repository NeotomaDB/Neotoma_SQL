CREATE OR REPLACE FUNCTION ap.datasetobject(_datasetid integer)
 RETURNS TABLE(datasetid integer, dataset jsonb)
 LANGUAGE sql
AS $function$
    SELECT dts.datasetid,
        jsonb_build_object('datasetid', dts.datasetid,
                       'datasettype', dst.datasettype,
                       'datasetnotes', dts.notes,
                       'database', cstdb.databasename,
                       'doi', json_agg(DISTINCT doi.doi),
                       'datasetpublications', json_agg(DISTINCT jsonb_build_object('publicationid', pub.publicationid,
                                                                         'citation', pub.citation)),
                       'datasetpi', json_agg(DISTINCT jsonb_build_object('contactid', cnt.contactid,
                                                            'contactname', cnt.contactname,
                                                            'familyname', cnt.familyname,
                                                            'firstname', cnt.givennames,
                                                            'initials', cnt.leadinginitials)),
                        'datasetprocessors', json_agg(DISTINCT jsonb_build_object('contactid', cntp.contactid,
                                                            'contactname', cntp.contactname,
                                                            'familyname', cntp.familyname,
                                                            'firstname', cntp.givennames,
                                                            'initials', cntp.leadinginitials)),
                             'agerange', json_agg(DISTINCT jsonb_build_object('ageyoung', agerange.younger,
                                                           'ageold', agerange.older,
                                                           'units', agetypes.agetype)),
                            'repository', json_agg(DISTINCT ri.repository))
                             AS dataset
    FROM
        ndb.datasets             AS dts
   LEFT OUTER JOIN ndb.datasettypes         AS dst      ON dst.datasettypeid = dts.datasettypeid
    LEFT OUTER JOIN ndb.datasetdoi           AS doi      ON dts.datasetid = doi.datasetid
   LEFT OUTER JOIN ndb.datasetdatabases     AS dsdb     ON dsdb.datasetid = dts.datasetid
    LEFT OUTER JOIN ndb.datasetpublications AS dtpub ON dtpub.datasetid = dts.datasetid
    LEFT OUTER JOIN ndb.publications AS pub ON pub.publicationid = dtpub.publicationid
   LEFT OUTER JOIN ndb.datasetpis           AS dspi     ON dspi.datasetid = dts.datasetid
    LEFT OUTER JOIN ndb.dataprocessors       AS dspr     ON dspr.datasetid = dts.datasetid
    LEFT OUTER JOIN ndb.contacts             AS cntp      ON cntp.contactid = dspi.contactid
   LEFT OUTER JOIN ndb.contacts             AS cnt      ON cnt.contactid = dspi.contactid
   LEFT OUTER JOIN ndb.dsageranges          AS agerange ON dts.datasetid = agerange.datasetid
   LEFT OUTER JOIN ndb.agetypes             AS agetypes ON agetypes.agetypeid = agerange.agetypeid
   LEFT OUTER JOIN ndb.constituentdatabases AS cstdb    ON dsdb.databaseid = cstdb.databaseid
    LEFT OUTER JOIN ndb.repositoryspecimens AS rpspec ON rpspec.datasetid = dts.datasetid
    LEFT OUTER JOIN ndb.repositoryinstitutions AS ri ON ri.repositoryid = rpspec.repositoryid
    WHERE dts.datasetid = _datasetid
    GROUP BY
        dts.datasetid,
      dst.datasettype,
      dts.notes,
      cstdb.databasename
$function$
