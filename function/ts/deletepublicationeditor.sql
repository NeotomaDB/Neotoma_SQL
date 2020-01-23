CREATE OR REPLACE FUNCTION ts.deletepublicationeditor(_editorid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.publicationeditors AS pes
WHERE pes.editorid = _editorid;
$function$
