CREATE OR REPLACE FUNCTION ti.getinvestigator(_datasetid integer)
 RETURNS TABLE(contactid integer, aliasid integer, contactname character varying, contactstatusid integer, familyname character varying, leadinginitials character varying, givennames character varying, suffix character varying, title character varying, phone character varying, fax character varying, email character varying, url character varying, address character varying, notes text)
 LANGUAGE sql
AS $function$


SELECT     con.ContactID, con.AliasID, con.ContactName, con.ContactStatusID, con.FamilyName, 
                      con.LeadingInitials, con.GivenNames, con.Suffix, con.Title, con.Phone, con.Fax, con.Email, 
                      con.URL, con.Address, con.Notes
FROM         NDB.DatasetPIs pis INNER JOIN
                      NDB.Contacts con ON pis.ContactID = con.ContactID
WHERE     (pis.DatasetID = _datasetid)

$function$
