CREATE OR REPLACE FUNCTION ti.getnextpublicationbyidandpubtypeid(_publicationid integer, _pubtypeid integer)
 RETURNS TABLE(publicationid integer, pubtypeid integer, year character varying, citation text, articletitle text, journal text, volume character varying, issue character varying, pages character varying, citationnumber character varying, doi character varying, booktitle text, numvolumes character varying, edition character varying, volumetitle text, seriestitle text, seriesvolume character varying, publisher character varying, url text, city character varying, state character varying, country character varying, originallanguage character varying, notes text)
 LANGUAGE plpgsql
AS $function$
DECLARE
nextpubid int;

BEGIN
nextpubid := (SELECT MIN (a.publicationid) FROM ndb.publications a WHERE a.publicationid > $1 and a.pubtypeid = $2);

RETURN QUERY
SELECT
 pub.publicationid,
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
pub.notes
FROM  ndb.publications pub
WHERE pub.publicationid = nextpubid;

END;
$function$
