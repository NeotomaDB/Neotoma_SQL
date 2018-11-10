CREATE OR REPLACE FUNCTION ts.insertisometadata(_dataid integer,
_isomatanaltypeid integer = null,
_isosubstratetypeid integer = null,
_analystid integer = null,
_lab character varying = null,
_labnumber character varying = null,
_massmg float = null,
_weightpercent float = null,
_atomicpercent float = null,
_reps integer = null
)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isometadata(dataid, isomatanaltypeid, isosubstratetypeid, analystid, lab, labnumber, mass_mg, weightpercent, atomicpercent, reps)
  VALUES (_dataid, _isomatanaltypeid, _isosubstratetypeid, _analystid, _lab, _labnumber, _massmg, _weightpercent, _atomicpercent, _reps)
$function$;
