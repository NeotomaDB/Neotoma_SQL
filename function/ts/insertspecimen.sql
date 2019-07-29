CREATE OR REPLACE FUNCTION ts.insertspecimen(_dataid integer, _elementtypeid integer DEFAULT NULL::integer, _symmetryid integer DEFAULT NULL::integer, _portionid integer DEFAULT NULL::integer, _maturityid integer DEFAULT NULL::integer, _sexid integer DEFAULT NULL::integer, _domesticstatusid integer DEFAULT NULL::integer, _preservative character varying DEFAULT NULL::character varying, _nisp double precision DEFAULT NULL::double precision, _repositoryid integer DEFAULT NULL::integer, _specimennr character varying DEFAULT NULL::character varying, _fieldnr character varying DEFAULT NULL::character varying, _arctosnr character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.specimens(dataid, elementtypeid, symmetryid, portionid, maturityid, sexid, domesticstatusid, preservative,
            nisp, repositoryid, specimennr, fieldnr, arctosnr, notes)
  VALUES (_dataid, _elementtypeid, _symmetryid, _portionid, _maturityid, _sexid, _domesticstatusid, _preservative,
  _nisp, _repositoryid, _specimennr, _fieldnr, _arctosnr, _notes)
  RETURNING specimenid
$function$
