CREATE OR REPLACE FUNCTION ts.insertsamplekeyword(_sampleid integer, _keywordid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.samplekeywords(sampleid, keywordid)
  VALUES (_sampleid, _keywordid)
$function$
