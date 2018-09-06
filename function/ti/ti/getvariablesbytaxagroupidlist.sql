CREATE OR REPLACE FUNCTION ti.getvariablesbytaxagroupidlist(_taxagrouplist character varying)
 RETURNS SETOF ndb.variables
 LANGUAGE sql
AS $function$
SELECT     vr.*
FROM
         ndb.variables AS vr
  INNER JOIN ndb.taxa AS tx ON vr.taxonid = tx.taxonid
WHERE
  tx.taxagroupid IN (SELECT unnest(string_to_array(_taxagrouplist,'$')))
$function$
