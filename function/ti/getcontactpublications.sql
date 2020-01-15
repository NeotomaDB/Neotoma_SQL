CREATE OR REPLACE FUNCTION ti.getcontactpublications(_contactid integer)
 RETURNS TABLE(contactid integer, citation text, year character varying, articletitle text, journal text, volume character varying, issue character varying, pages character varying, citationnumber character varying, doi character varying, booktitle text, numvolumes character varying, edition character varying, volumetitle text, seriestitle text, seriesvolume character varying, publisher character varying, url text, city character varying, state character varying, country character varying, originallanguage character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.publicationauthors.contactid, ndb.publications.citation, ndb.publications.year, ndb.publications.articletitle, ndb.publications.journal, 
       ndb.publications.volume, ndb.publications.issue, ndb.publications.pages, ndb.publications.citationnumber, ndb.publications.doi, 
       ndb.publications.booktitle, ndb.publications.numvolumes, ndb.publications.edition, ndb.publications.volumetitle, ndb.publications.seriestitle, 
       ndb.publications.seriesvolume, ndb.publications.publisher, ndb.publications.url, ndb.publications.city, ndb.publications.state, 
       ndb.publications.country, ndb.publications.originallanguage
FROM ndb.publicationauthors INNER JOIN
     ndb.publications ON ndb.publicationauthors.publicationid = ndb.publications.publicationid
WHERE ndb.publicationauthors.contactid = _contactid;
$function$
