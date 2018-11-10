CREATE OR REPLACE FUNCTION ts.insertisoinstrumention(_datasetid integer,
_variableid integer,
_isoinstrumentationtypeid integer = null,
_isosampleintrosystemtypeid integer = null,
_insterrorpercent float = null,
_insterrorrunsd float = null,
_insterrorlongtermpercent float = null,
_notes character varying = null
)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isoinstrumentation (datasetid, variableid, isoinstrumentationtypeid, isosampleintrosystemtypeid,
                                    insterrorpercent, insterrorrunsd, insterrorlongtermpercent, notes)
  VALUES (_datasetid, _variableid, _isoinstrumentationtypeid, _isosampleintrosystemtypeid, _insterrorpercent, _insterrorrunsd, _insterrorlongtermpercent, _notes)
$function$;
