CREATE OR REPLACE FUNCTION ts.insertsteward(
    _contactid integer,
    _username character varying,
    _password character varying,
    _taxonomyexpert boolean,
    _databaseid integer)
    RETURNS void
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$

  insert into ti.stewards(contactid, username, pwd, taxonomyexpert)
  values      (_contactid, _username, _password, _taxonomyexpert);

  insert into ti.stewarddatabases(stewardid, databaseid)
  values      ((select stewardid from ti.stewards where (contactid = _contactid)), _databaseid)
$BODY$;