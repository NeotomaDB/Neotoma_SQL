CREATE OR REPLACE FUNCTION ts.insertaggregatechronology(
	_aggregatedatasetid integer,
	_agetypeid integer,
	_isdefault smallint,
	_chronologyname character varying,
	_ageboundyounger integer,
	_ageboundolder integer,
	_notes character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.aggregatechronologies
	(aggregatedatasetid, agetypeid, isdefault, chronologyname, ageboundyounger, ageboundolder, notes)
VALUES (_aggregatedatasetid, _agetypeid, _isdefault, _chronologyname, _ageboundyounger, _ageboundolder, _notes)
$function$;
---return id
SELECT scope_identity();
