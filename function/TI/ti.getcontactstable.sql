CREATE OR REPLACE FUNCTION ti.getcontactstable()
RETURNS TABLE(contactid int, aliasid int, contactname varchar(80), contactstatusid int, familyname varchar(80), leadinginitials varchar(16),
			givennames varchar(80), suffix varchar(16), title varchar(16), phone varchar(64), fax varchar(64), email varchar(64), url varchar(255),
			address text, notes text, recdatecreated timestamp(0) without time zone, recdatemodified timestamp(0) without time zone)
AS $$
SELECT *
FROM ndb.contacts;
$$ LANGUAGE SQL;