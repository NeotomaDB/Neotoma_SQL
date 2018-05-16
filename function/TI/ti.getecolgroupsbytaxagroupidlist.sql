CREATE OR REPLACE FUNCTION ti.getecolgroupsbytaxagroupidlist(_taxagrouplist text)
RETURNS TABLE(taxonid int, ecolsetid int, ecolgroupid varchar(4), recdatecreated timestamp(0) without time zone,
		recdatemodified timestamp(0) without time zone )
AS $$
SELECT ndb.ecolgroups.*
FROM ndb.ecolgroups INNER JOIN ndb.taxa ON ndb.ecolgroups.taxonid = ndb.taxa.taxonid
WHERE (ndb.taxa.taxagroupid IN (
	SELECT unnest(string_to_array(_taxagrouplist,'$'))::text
	))
$$ LANGUAGE SQL;


 