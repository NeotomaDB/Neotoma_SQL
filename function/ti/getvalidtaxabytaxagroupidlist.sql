CREATE OR REPLACE FUNCTION ti.getvalidtaxabytaxagroupidlist(taxagrouplist character varying)
 RETURNS TABLE(taxonid integer,
               taxoncode character varying,
               taxonname character varying,
               author character varying,
               valid boolean,
               highertaxonid integer,
               extinct boolean,
               taxagroupid character varying,
               publicationid integer,
               validatorid integer,
               validatedate character varying,
               notes character varying)
 LANGUAGE sql
AS $function$
select
  tx.taxonid,
  tx.taxoncode,
  tx.taxonname,
  tx.author,
  tx.valid,
  tx.highertaxonid,
  tx.extinct,
  tx.taxagroupid,
  tx.publicationid,
  tx.validatorid,
  TO_CHAR(tx.validatedate, 'YYYY-MM-DD HH:MI:SS') as validatedate,
  notes
FROM
  ndb.taxa AS tx
WHERE
  (tx.valid = True) AND
  (tx.taxagroupid IN (
    SELECT unnest(string_to_array(taxagrouplist,'$')))
  )
$function$
