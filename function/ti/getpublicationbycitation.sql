CREATE OR REPLACE FUNCTION ti.getpublicationbycitation(_citation character varying)
 RETURNS TABLE(publicationid integer, pubtypeid integer, year character varying, citation text, articletitle text, journal text, volume character varying, issue character varying, pages character varying, citationnumber character varying, doi character varying, booktitle text, numvolumes character varying, edition character varying, volumetitle text, seriestitle text, seriesvolume character varying, publisher character varying, url text, city character varying, state character varying, country character varying, originallanguage character varying, notes text)
 LANGUAGE sql
AS $function$
SELECT publicationid, pubtypeid, year, citation, articletitle, journal, volume, issue, pages, citationnumber, doi, booktitle, numvolumes, edition,
volumetitle, seriestitle, seriesvolume, publisher, url, city, state, country, originallanguage, notes
FROM ndb.publications
WHERE citation ILIKE _citation;
$function$
