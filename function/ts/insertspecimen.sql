CREATE OR REPLACE FUNCTION ts.insertspecimen(_dataid integer,
_elementtypeid integer = null,
_symmetryid integer = null,
_portionid integer = null,
_maturityid integer = null,
_sexid integer = null,
_domesticstatusid integer = null,
_preservative character varying = null,
_nisp float = null,
_repositoryid integer = null,
_specimennr character varying = null,
_fieldnr character varying = null,
_arctosnr character varying = null,
_notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.specimens(dataid, elementtypeid, symmetryid, portionid, maturityid, sexid, domesticstatusid, preservative,
            nisp, repositoryid, specimennr, fieldnr, arctosnr, notes)
  VALUES (_dataid, _elementtypeid, _symmetryid, _portionid, _maturityid, _sexid, _domesticstatusid, _preservative,
  _nisp, _repositoryid, _specimennr, _fieldnr, _arctosnr, _notes)
  RETURNING specimenid
$function$;
