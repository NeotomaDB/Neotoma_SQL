CREATE OR REPLACE FUNCTION ti.getdatasetcitations(_datasetid integer)
 RETURNS TABLE(primarypub    boolean,
               publicationid integer,
               citation      text)
 LANGUAGE sql
AS $function$
SELECT dpu.primarypub,
       pub.publicationid,
       pub.citation
FROM  ndb.datasetpublications AS dpu
  INNER JOIN ndb.publications AS pub ON dpu.publicationid = pub.publicationid
WHERE dpu.datasetid = _datasetid;
$function$
