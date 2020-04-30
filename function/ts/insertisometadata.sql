CREATE OR REPLACE FUNCTION ts.insertisometadata(_dataid integer,
                                                _isomatanaltypeid integer DEFAULT NULL::integer,
                                                _isosubstratetypeid integer DEFAULT NULL::integer,
                                                _analystid integer DEFAULT NULL::integer,
                                                _lab character varying DEFAULT NULL::character varying,
                                                _labnumber character varying DEFAULT NULL::character varying,
                                                _massmg double precision DEFAULT NULL::double precision,
                                                _weightpercent double precision DEFAULT NULL::double precision,
                                                _atomicpercent double precision DEFAULT NULL::double precision,
                                                _reps integer DEFAULT NULL::integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isometadata(dataid, isomatanaltypeid, isosubstratetypeid, analystid, lab, labnumber, mass_mg, weightpercent, atomicpercent, reps)
  VALUES (_dataid, _isomatanaltypeid, _isosubstratetypeid, _analystid, _lab, _labnumber, _massmg, _weightpercent, _atomicpercent, _reps)
$function$
