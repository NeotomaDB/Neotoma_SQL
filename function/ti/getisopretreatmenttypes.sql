CREATE OR REPLACE FUNCTION ti.getisopretreatmenttypes()
 RETURNS TABLE(isopretreatmenttypeid integer, isopretreatmenttype character varying, isopretreatmentqualifier character varying)
 LANGUAGE sql
AS $function$
SELECT      isopretreatmenttypeid, 
            isopretreatmenttype, 
            isopretreatmentqualifier
 FROM ndb.isopretreatmenttypes;
$function$
