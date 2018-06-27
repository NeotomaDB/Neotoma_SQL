CREATE OR REPLACE FUNCTION ap.getpeople()
 RETURNS TABLE(contactid integer, contactname character varying)
 LANGUAGE sql
AS $function$
WITH auth_pi AS (
(SELECT DISTINCT dpi.contactid, c.contactname
FROM ndb.datasetpis AS dpi INNER JOIN
ndb.contacts AS c ON c.contactid = dpi.contactid)
UNION
(SELECT DISTINCT pa.contactid, c.contactname
FROM ndb.publicationauthors AS pa INNER JOIN
ndb.contacts AS c ON c.contactid = pa.contactid)
), alia AS (
SELECT c.contactid, c.contactname
FROM ndb.contacts AS c
WHERE c.contactid != c.aliasid AND c.aliasid > 0 AND c.aliasid IN (SELECT contactid FROM auth_pi)
)
SELECT * FROM (SELECT * FROM auth_pi) AS q UNION (SELECT * FROM alia);
$function$
