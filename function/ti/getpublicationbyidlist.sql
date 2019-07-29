CREATE OR REPLACE FUNCTION ti.getpublicationbyidlist(_publicationidlist character varying)
 RETURNS SETOF ndb.publications
 LANGUAGE sql
AS $function$
  SELECT *
  FROM ndb.publications
  WHERE publicationid in (SELECT unnest(string_to_array(_publicationidlist,'$'))::int)
$function$
