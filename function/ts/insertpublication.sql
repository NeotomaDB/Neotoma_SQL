CREATE OR REPLACE FUNCTION ts.insertpublication(_pubtypeid integer,
  _year character varying DEFAULT NULL::character varying,
  _citation character varying DEFAULT NULL::character varying,
  _title character varying DEFAULT NULL::character varying,
  _journal character varying DEFAULT NULL::character varying,
  _vol character varying DEFAULT NULL::character varying,
  _issue character varying DEFAULT NULL::character varying,
  _pages character varying DEFAULT NULL::character varying,
  _citnumber character varying DEFAULT NULL::character varying,
  _doi character varying DEFAULT NULL::character varying,
  _booktitle character varying DEFAULT NULL::character varying,
  _numvol character varying DEFAULT NULL::character varying,
  _edition character varying DEFAULT NULL::character varying,
  _voltitle character varying DEFAULT NULL::character varying,
  _sertitle character varying DEFAULT NULL::character varying,
  _servol character varying DEFAULT NULL::character varying,
  _publisher character varying DEFAULT NULL::character varying,
  _url character varying DEFAULT NULL::character varying,
  _city character varying DEFAULT NULL::character varying,
  _state character varying DEFAULT NULL::character varying,
  _country character varying DEFAULT NULL::character varying,
  _origlang character varying DEFAULT NULL::character varying,
  _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.publications(pubtypeid, year, citation, articletitle, journal,
      volume, issue, pages, citationnumber, doi, booktitle, numvolumes, edition,
      volumetitle, seriestitle, seriesvolume, publisher, url, city, state,
      country, originallanguage, notes)
  VALUES (_pubtypeid, _year, _citation, _title, _journal, _vol, _issue, _pages,
  _citnumber, _doi, _booktitle, _numvol, _edition, _voltitle, _sertitle,
  _servol, _publisher, _url, _city, _state, _country, _origlang, _notes)
  RETURNING publicationid
$function$
