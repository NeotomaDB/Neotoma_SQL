CREATE OR REPLACE FUNCTION ti.getinvalidtaxabytaxagroupidlist(_taxagrouplist text)
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
               notes text)
 LANGUAGE sql
AS $function$


SELECT      taxonid, taxoncode, taxonname, author, valid, highertaxonid, extinct, taxagroupid, publicationid, validatorid,
               TO_CHAR(tx.validatedate, 'YYYY-MM-DD HH:MI:SS') AS validatedate, notes
FROM          NDB.Taxa tx
WHERE      (valid = False) AND (taxagroupid  = ANY ( string_to_array(_taxagrouplist,'$') ));

$function$
