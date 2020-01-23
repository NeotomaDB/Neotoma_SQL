CREATE OR REPLACE FUNCTION ts.insertisoinstrumention(_datasetid integer, _variableid integer, _isoinstrumentationtypeid integer DEFAULT NULL::integer, _isosampleintrosystemtypeid integer DEFAULT NULL::integer, _insterrorpercent double precision DEFAULT NULL::double precision, _insterrorrunsd double precision DEFAULT NULL::double precision, _insterrorlongtermpercent double precision DEFAULT NULL::double precision, _notes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isoinstrumentation (datasetid, variableid, isoinstrumentationtypeid, isosampleintrosystemtypeid,
                                    insterrorpercent, insterrorrunsd, insterrorlongtermpercent, notes)
  VALUES (_datasetid, _variableid, _isoinstrumentationtypeid, _isosampleintrosystemtypeid, _insterrorpercent, _insterrorrunsd, _insterrorlongtermpercent, _notes)
$function$
