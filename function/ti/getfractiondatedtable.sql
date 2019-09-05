CREATE OR REPLACE FUNCTION ti.getfractiondatedtable()
RETURNS TABLE(fractionid int, fraction character varying(80))
AS $$

select fractionid, fraction
from ndb.fractiondated

$$ LANGUAGE SQL;
