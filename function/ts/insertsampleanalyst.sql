CREATE OR REPLACE FUNCTION ts.insertsampleanalyst(_sampleid integer, _contactid integer, _analystorder integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.sampleanalysts(sampleid, contactid, analystorder)
  VALUES (_sampleid, _contactid, _analystorder)
  RETURNING analystid
$function$;
