CREATE OR REPLACE FUNCTION ts.insertpublication(_pubtypeid integer,
      _year character varying = null,
      _citation character varying = null,
      _title character varying = null,
      _journal character varying = null,
      _vol character varying = null,
      _issue character varying = null,
      _pages character varying = null,
      _citnumber character varying = null,
      _doi character varying = null,
      _booktitle character varying = null,
      _numvol character varying = null,
      _edition character varying = null,
      _voltitle character varying = null,
      _sertitle character varying = null,
      _servol character varying = null,
      _publisher character varying = null,
      _url character varying = null,
      _city character varying = null,
      _state character varying = null,
      _country character varying = null,
      _origlang character varying = null,
      _notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.publications(pubtypeid, year, citation, articletitle, journal,
      volume, issue, pages, citationnumber, doi, booktitle, numvolumes, edition,
      volumetitle, seriestitle, seriesvolume, publisher, url, city, state,
      country, originallanguage, notes)
  VALUES (_pubtypeid, _year, _citation, _title, _journal, _vol, _issue, _pages,
  _citnumber, _doi, _booktitle, _numvol, _edition, _voltitle, _sertitle,
  _servol, _publisher, _url, _city, _state, _country, _origlang, _note)
  RETURNING publicationid
$function$;
