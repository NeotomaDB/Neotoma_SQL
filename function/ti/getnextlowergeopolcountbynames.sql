CREATE OR REPLACE FUNCTION ti.getnextlowergeopolcountbynames(_name1 character varying, _rank1 integer, _name2 character varying, _rank2 integer)
 RETURNS bigint
 LANGUAGE sql
AS $function$
SELECT COUNT(geopoliticalunits_1.geopoliticalname) AS count
FROM ndb.geopoliticalunits INNER JOIN
		ndb.geopoliticalunits AS geopoliticalunits_1 ON ndb.geopoliticalunits.geopoliticalid = geopoliticalunits_1.highergeopoliticalid
WHERE (ndb.geopoliticalunits.geopoliticalname = _name1) AND (ndb.geopoliticalunits.rank = _rank1) AND
		(geopoliticalunits_1.geopoliticalname = _name2) AND (geopoliticalunits_1.rank = _rank2);
$function$
