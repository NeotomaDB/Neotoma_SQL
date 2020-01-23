CREATE OR REPLACE FUNCTION ap.getauthors()
 RETURNS TABLE(contactid integer, contactname character varying)
 LANGUAGE sql
AS $function$
    
With _authortable AS (

    select distinct pa.contactid, c.contactname
    from ndb.publicationauthors as pa inner join
    ndb.contacts as c on c.contactid = pa.contactid
),

_contactaliases AS (
    select c.contactid, c.contactname
    from ndb.contacts as c
    where c.contactid != c.aliasid and c.aliasid > 0 and c.aliasid in (select contactid from _authortable)
)

Select * from _authortable

	union all
	
select * from _contactaliases
	
	
$function$
