CREATE OR REPLACE FUNCTION ts.insertsteward(_contactid integer,
                                            _username character varying,
                                            _password character varying,
                                            _taxonomyexpert boolean,
                                            _databaseid integer)
 RETURNS integer
 LANGUAGE sql
AS $function$

  insert into ti.stewards(contactid, username, pwd, taxonomyexpert)
  values      (_contactid, _username, _password, _taxonomyexpert);

  WITH newstew AS (
    SELECT stewardid,
      _databaseid AS dbid
    FROM ti.stewards AS stw WHERE (stw.contactid = _contactid))
  insert into ti.stewarddatabases(stewardid, databaseid)
  values      ((select stewardid from ti.stewards AS stw where (stw.contactid = _contactid)), _databaseid)
  RETURNING stewardid
$function$
