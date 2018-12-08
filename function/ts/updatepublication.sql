CREATE OR REPLACE FUNCTION ts.updatepublication(
  _publicationid integer,
  _pubtypeid integer,
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
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.publications
	SET   pubtypeid = _pubtypeid, year = _year, citation = _citation,
    articletitle = _title, journal = _journal, volume = _vol, issue = _issue,
    pages = _pages, citationnumber = _citnumber, doi = _doi,
    booktitle = _booktitle, numvolumes = _numvol, edition = _edition,
    volumetitle = _voltitle, seriestitle = _sertitle, seriesvolume = _servol,
    publisher = _publisher, url = _url, city = _city, state = _state,
    country = _country, originallanguage = _origlang, notes = _notes
	WHERE publicationid = _publicationid
$function$;
