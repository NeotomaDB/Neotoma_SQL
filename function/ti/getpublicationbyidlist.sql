CREATE OR REPLACE FUNCTION ti.getpublicationbyidlist(_publicationidlist character varying)
 RETURNS TABLE(publicationid integer, pubtypeid integer, year character varying, citation text, articletitle text, journal text, volume character varying, issue character varying, pages character varying, citationnumber character varying, doi character varying, booktitle text, numvolumes character varying, edition character varying, volumetitle text, seriestitle text, seriesvolume character varying, publisher character varying, url text, city character varying, state character varying, country character varying, originallanguage character varying, notes text)
 LANGUAGE sql
AS $function$
  SELECT b.publicationid, b.pubtypeid, b.year, b.citation, b.articletitle, b.journal, b.volume, b.issue, b.pages, b.citationnumber,
  		b.doi, b.booktitle, b.numvolumes, b.edition, b.volumetitle, b.seriestitle, b.seriesvolume, b.publisher, b.url, b.city, b.state,
		b.country, b.originallanguage, b.notes
  FROM ndb.publications b
  WHERE b.publicationid in (SELECT unnest(string_to_array($1,'$'))::int)
$function$
