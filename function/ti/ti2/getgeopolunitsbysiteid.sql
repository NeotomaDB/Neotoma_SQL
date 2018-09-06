CREATE OR REPLACE FUNCTION ti.getgeopolunitsbysiteid(_siteid integer)
 RETURNS TABLE(geopoliticalid integer, geopoliticalname character varying, geopoliticalunit character varying, rank integer, highergeopoliticalid integer)
 LANGUAGE sql
AS $function$


SELECT      gp.geopoliticalid, gp.geopoliticalname, gp.geopoliticalunit, gp.rank, gp.highergeopoliticalid
FROM        ndb.sitegeopolitical sg INNER JOIN
            ndb.geopoliticalunits gp ON sg.GeoPoliticalID = gp.geopoliticalid
WHERE       (sg.siteid = _siteid)
ORDER BY    gp.rank



$function$
