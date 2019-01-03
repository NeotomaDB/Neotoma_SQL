CREATE OR REPLACE FUNCTION ts.getnextpublicationbyidandpubtypeid(_publicationid integer, _pubtypeid integer)
RETURNS TABLE (publicationid integer, pubtypeid integer, year character varying, citation character varying,
       articletitle character varying, journal character varying, volume character varying,
       issue character varying, pages character varying, citationnumber character varying,
       doi character varying, booktitle character varying, numvolumes character varying,
       edition character varying, volumetitle character varying,
       seriestitle character varying, seriesvolume character varying,
       publisher character varying, url character varying, city character varying,
       state character varying, country character varying,
       originallanguage character varying, notes character varying)
LANGUAGE sql
AS $function$

SELECT  	(pub.publicationid,
	pub.pubtypeid,
	pub.year,
	pub.citation,
	pub.articletitle,
	pub.journal,
	pub.volume,
	pub.issue,
	pub.pages,
	pub.citationnumber,
	pub.doi,
	pub.booktitle,
	pub.numvolumes,
	pub.edition,
	pub.volumetitle,
	pub.seriestitle,
	pub.seriesvolume,
	pub.publisher,
	pub.url,
	pub.city,
	pub.state,
	pub.country,
	pub.originallanguage,
	pub.notes)
FROM ndb.publications AS pub
WHERE publicationid = (
  SELECT MIN(pub.publicationid)
  FROM   ndb.publications AS pub
  where  (publicationid > _publicationid and pubtypeid = _pubtypeid)
)
$function$
