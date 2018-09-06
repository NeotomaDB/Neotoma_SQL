CREATE OR REPLACE FUNCTION ti.getsitemetadata(_siteid integer)
 RETURNS TABLE(siteid integer, sitename character varying, geog character varying, altitude double precision, area double precision, sitedescription character varying, notes character varying)
 LANGUAGE sql
AS $function$
  select              st.siteid,
                    st.sitename,
              ST_AsText(st.geog) as geog,
                    st.altitude,
                        st.area,
             st.sitedescription,
                       st.notes
  from        ndb.sites AS st
  where       st.siteid = _siteid
$function$
