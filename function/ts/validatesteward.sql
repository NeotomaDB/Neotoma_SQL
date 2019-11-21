CREATE OR REPLACE FUNCTION ts.validatesteward(_username character varying, _pwd character varying)
 RETURNS TABLE(databaseid integer)
 LANGUAGE sql
AS $function$

    SELECT     ndb.constituentdatabases.databaseid
    FROM         ti.stewards INNER JOIN
                          ti.stewarddatabases on ti.stewards.stewardid = ti.stewarddatabases.stewardid inner join
                          ndb.constituentdatabases on ti.stewarddatabases.databaseid = ndb.constituentdatabases.databaseid
    WHERE     (ti.stewards.username = _username) and (ti.stewards.pwd = _pwd)

$function$
