CREATE OR REPLACE FUNCTION ti.getsynonymtype(_synonymtype character varying)
 RETURNS TABLE(synonymtypeid integer, synonymtype character varying)
 LANGUAGE sql
 AS $function$

 SELECT
 	st.synonymtypeid,
	st.synonymtype
 FROM       ndb.synonymtypes as st
 WHERE      st.synonymtype = _synonymtype

$function$
