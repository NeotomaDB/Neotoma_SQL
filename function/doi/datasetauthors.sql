CREATE OR REPLACE FUNCTION doi.datasetauthors(dsid integer)
RETURNS TABLE(datasetid integer, authors jsonb)
 LANGUAGE sql
AS $function$
  SELECT dst.datasetid,  jsonb_agg(jsonb_build_object('contactid', cnt.contactid,
                                'contactname', cnt.contactname,
                                 'familyname', cnt.familyname,
                                  'firstname', cnt.givennames,
                                   'initials', cnt.leadinginitials)) AS authors
  FROM ndb.datasets AS dst
  JOIN ndb.datasetpis AS dspi ON dspi.datasetid = dst.datasetid LEFT OUTER JOIN
  ndb.contacts AS cnt ON cnt.contactid = dspi.contactid
  WHERE dst.datasetid = dsid
  GROUP BY dst.datasetid;
$function$;

CREATE OR REPLACE FUNCTION doi.datasetauthors(dsid integer[])
 RETURNS TABLE(datasetid integer, authors jsonb)
 LANGUAGE sql
AS $function$
  SELECT dst.datasetid,  jsonb_agg(jsonb_build_object('contactid', cnt.contactid,
                                'contactname', cnt.contactname,
                                 'familyname', cnt.familyname,
                                  'firstname', cnt.givennames,
                                   'initials', cnt.leadinginitials)) AS authors
  FROM ndb.datasets AS dst
  JOIN ndb.datasetpis AS dspi ON dspi.datasetid = dst.datasetid LEFT OUTER JOIN
  ndb.contacts AS cnt ON cnt.contactid = dspi.contactid
  WHERE dst.datasetid = ANY(dsid)
  GROUP BY dst.datasetid;
$function$
