CREATE OR REPLACE FUNCTION ti.getnextlowergeopolcountbynames(_name1 character varying, _rank1 integer, _name2 character varying, _rank2 integer)
 RETURNS TABLE (count bigint)
 LANGUAGE sql
AS $function$
  SELECT COUNT(gpu_1.geopoliticalname) AS count
  FROM ndb.geopoliticalunits AS gpu
    INNER JOIN
  		ndb.geopoliticalunits AS gpu_1 ON gpu.geopoliticalid = gpu_1.highergeopoliticalid
  WHERE (gpu.geopoliticalname ILIKE _name1) AND (gpu.rank = _rank1) AND
  		(gpu_1.geopoliticalname ILIKE _name2) AND (gpu_1.rank = _rank2);
$function$;
