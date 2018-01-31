CREATE OR REPLACE FUNCTION ti.getchronologiesbycollunitid(collunitid int) RETURNS SETOF record
AS $$
SELECT ndb.chronologies.chronologyid, ndb.agetypes.agetype, ndb.chronologies.chronologyname, 
       ndb.chronologies.isdefault, ndb.chronologies.agemodel, ndb.chronologies.ageboundolder, ndb.chronologies.ageboundyounger,   
       ndb.chronologies.contactid, ndb.chronologies.dateprepared::varchar(10) AS dateprepared, ndb.chronologies.notes
FROM ndb.chronologies INNER JOIN ndb.agetypes ON ndb.chronologies.agetypeid = ndb.agetypes.agetypeid
WHERE ndb.chronologies.collectionunitid = collunitid
ORDER BY ndb.chronologies.chronologyid;
$$ LANGUAGE SQL;