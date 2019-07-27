CREATE OR REPLACE FUNCTION ti.getfaunmap1relativeagesbychroncontrolidlist(_chroncontrolids character varying)
 RETURNS TABLE(chroncontrolid integer, relativeagescale character varying, relativeageunit character varying, relativeage character varying, c14ageolder double precision, c14ageyounger double precision, calageolder double precision, calageyounger double precision)
 LANGUAGE sql
AS $function$
SELECT ndb.chroncontrols.chroncontrolid, ndb.relativeagescales.relativeagescale, ndb.relativeageunits.relativeageunit, ndb.relativeages.relativeage,
		ndb.relativeages.c14ageolder, ndb.relativeages.c14ageyounger, ndb.relativeages.calageolder, ndb.relativeages.calageyounger
FROM ndb.relativechronology INNER JOIN
                      ndb.relativeages on ndb.relativechronology.relativeageid = ndb.relativeages.relativeageid INNER JOIN
                      ndb.chroncontrols on ndb.relativechronology.analysisunitid = ndb.chroncontrols.analysisunitid INNER JOIN
                      ndb.relativeagescales on ndb.relativeages.relativeagescaleid = ndb.relativeagescales.relativeagescaleid INNER JOIN
                      ndb.relativeageunits on ndb.relativeages.relativeageunitid = ndb.relativeageunits.relativeageunitid
WHERE ndb.chroncontrols.chroncontrolid in (SELECT unnest(string_to_array(_chroncontrolids,'$'))::int)
$function$
