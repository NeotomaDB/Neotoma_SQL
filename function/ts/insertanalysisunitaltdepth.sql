CREATE OR REPLACE FUNCTION ts.insertanalysisunitaltdepth(_analysisunitid integer, _altdepthscaleid integer, _altdepth double precision)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.analysisunitaltdepths(analysisunitid, altdepthscaleid, altdepth)
VALUES (_analysisunitid, _altdepthscaleid, _altdepth)
$function$
