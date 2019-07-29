CREATE OR REPLACE FUNCTION ts.updatepublication(_publicationid integer, _pubtypeid integer, _year character varying DEFAULT NULL::character varying, _citation character varying DEFAULT NULL::character varying, _title character varying DEFAULT NULL::character varying, _journal character varying DEFAULT NULL::character varying, _vol character varying DEFAULT NULL::character varying, _issue character varying DEFAULT NULL::character varying, _pages character varying DEFAULT NULL::character varying, _citnumber character varying DEFAULT NULL::character varying, _doi character varying DEFAULT NULL::character varying, _booktitle character varying DEFAULT NULL::character varying, _numvol character varying DEFAULT NULL::character varying, _edition character varying DEFAULT NULL::character varying, _voltitle character varying DEFAULT NULL::character varying, _sertitle character varying DEFAULT NULL::character varying, _servol character varying DEFAULT NULL::character varying, _publisher character varying DEFAULT NULL::character varying, _url character varying DEFAULT NULL::character varying, _city character varying DEFAULT NULL::character varying, _state character varying DEFAULT NULL::character varying, _country character varying DEFAULT NULL::character varying, _origlang character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
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
$function$
