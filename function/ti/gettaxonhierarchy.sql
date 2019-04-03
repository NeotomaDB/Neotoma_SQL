CREATE OR REPLACE FUNCTION ti.gettaxonhierarchy(_taxonname character varying)
 RETURNS TABLE(taxonid integer, taxonname character varying, valid boolean, highertaxonid integer)
 LANGUAGE sql
AS $function$
WITH RECURSIVE lowertaxa AS (SELECT
              txa.taxonid, 
              txa.highertaxonid
         FROM ndb.taxa AS txa
        WHERE 
          (LOWER(txa.taxonname) LIKE _taxonname)
        UNION ALL
       SELECT m.taxonid, 
			   m.highertaxonid
         FROM ndb.taxa AS m
         JOIN lowertaxa ON lowertaxa.taxonid = m.highertaxonid)

SELECT txa.taxonid,
       txa.taxonname,
	   txa.valid,
       txa.highertaxonid
FROM
  lowertaxa AS taxa
LEFT OUTER JOIN
  ndb.taxa AS txa ON txa.taxonid = taxa.taxonid

$function$
