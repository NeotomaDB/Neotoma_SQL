CREATE OR REPLACE FUNCTION ti.getchildtaxa(_taxonname character varying)
 RETURNS TABLE(taxonid integer,
             taxonname character varying,
                author character varying,
         highertaxonid integer,
                 level integer)
LANGUAGE sql
AS $function$
  WITH  RECURSIVE taxacte
  AS
  (
  	SELECT taxonid AS basetaxonid, taxonid, taxonname, author, highertaxonid, 0 AS level
      FROM ndb.taxa
      WHERE taxonname ILIKE $1

      UNION ALL

      SELECT parent.basetaxonid, child.taxonid, child.taxonname, child.author, child.highertaxonid, parent.level +1 AS level
      FROM taxacte AS parent
        INNER JOIN ndb.taxa AS child
          ON parent.taxonid = child.highertaxonid
  )
   SELECT taxonid, taxonname, author, highertaxonid, level
   FROM taxacte
   ORDER BY level
$function$
