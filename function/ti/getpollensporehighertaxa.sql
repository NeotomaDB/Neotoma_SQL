CREATE OR REPLACE FUNCTION ti.getpollensporehighertaxa(_taxaidlist character varying)
 RETURNS TABLE(taxonid integer, highertaxonid integer)
 LANGUAGE sql
AS $function$
  WITH RECURSIVE txtable (oid, taxonid, highertaxonid) AS (
  (SELECT tx.taxonid AS oid, tx.taxonid, tx.highertaxonid
  FROM ndb.taxa AS tx
  WHERE tx.taxonid IN (SELECT UNNEST(string_to_array(_taxaidlist,'$'))::int))
  UNION ALL
  (SELECT tx.oid, txo.taxonid, txo.highertaxonid
   FROM txtable AS tx
   INNER JOIN ndb.taxa AS txo ON txo.taxonid = tx.highertaxonid
  WHERE txo.taxonid <> txo.highertaxonid)
  )
  SELECT oid AS taxonid,
       MIN(highertaxonid) AS highertaxonid
  FROM txtable
  WHERE highertaxonid = taxonid OR
      highertaxonid IN (5480, 9534, 33038)
  GROUP BY oid
$function$
