CREATE OR REPLACE FUNCTION ti.getpreviouspublicationbyidandpubtypeid(_publicationid int, _pubtypeid int)
RETURNS TABLE (publicationid int,
	pubtypeid integer,
	year character varying(64),
	citation text,
	articletitle text,
	journal text,
	volume character varying(16),
	issue character varying(8),
	pages character varying(24),
	citationnumber character varying(24),
	doi character varying(128),
	booktitle text,
	numvolumes character varying(8),
	edition character varying(24),
	volumetitle text,
	seriestitle text,
	seriesvolume character varying(24),
	publisher character varying(255),
	url text,
	city character varying(64),
	state character varying(64),
	country character varying(64),
	originallanguage character varying(64),
	notes text)
AS $$
DECLARE

	prevpubid int;

BEGIN
	prevpubid := (SELECT MAX(a.publicationid) FROM ndb.publications a WHERE a.publicationid < $1 AND a.pubtypeid = $2);

	RETURN QUERY SELECT b.publicationid, b.pubtypeid, b.year, b.citation, b.articletitle, b.journal, b.volume, b.issue, b.pages, b.citationnumber,
		b.doi, b.booktitle, b.numvolumes, b.edition, b.volumetitle, b.seriestitle, b.seriesvolume, b.publisher, b.url, b.city, b.state,
		b.country, b.originallanguage, b.notes
		FROM ndb.publications b WHERE b.publicationid = prevpubid;

END;
$$ LANGUAGE PLPGSQL;