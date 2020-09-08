CREATE OR REPLACE FUNCTION da.chronologybyid(_chronid integer)
 RETURNS TABLE(controls json,
               "Default" boolean,
               ChronologyName character varying,
               AgeType character varying,
               AgeModel character varying,
               AgeOlder integer,
               ChronologyID integer,
               AgeYounger integer,
               datasets json,
               notes character varying,
               dateprepared date)
 LANGUAGE sql
AS $function$

  SELECT json_agg(json_build_object('AgeYoungest', ccr.agelimityounger,
                                            'Age', ccr.age,
                                    'ControlType', ccrt.chroncontroltype,
                  'ChronControlID', ccr.chroncontrolid,
                  'Depth', ccr.depth,
                  'AgeOldest', ccr.agelimitolder,
                  'Thickness', ccr.thickness)) AS controls,
        chr.isdefault AS Default,
        chr.chronologyname AS ChronologyName,
        aty.agetype AS AgeType,
        chr.agemodel AS AgeModel,
        chr.ageboundolder AS AgeOlder,
        chr.chronologyid AS ChronologyID,
        chr.ageboundyounger AS AgeYounger,
        json_agg(json_build_object('DatasetType', dst.datasettype,
                                     'DatasetID', ds.datasetid)) AS datasets,
        chr.notes AS Notes,
        chr.dateprepared AS DatePrepared
  FROM ndb.chronologies AS chr
  INNER JOIN ndb.agetypes AS aty ON chr.agetypeid = aty.agetypeid
  LEFT JOIN ndb.chroncontrols AS ccr ON chr.chronologyid = ccr.chronologyid
  LEFT JOIN ndb.chroncontroltypes AS ccrt ON ccr.chroncontroltypeid = ccrt.chroncontroltypeid
  LEFT JOIN ndb.datasets AS ds ON  ds.collectionunitid = chr.collectionunitid
  LEFT JOIN ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
  WHERE chr.chronologyid = 123
  GROUP BY chr.isdefault,
        chr.chronologyname,
        aty.agetype,
        chr.ageboundolder,
        chr.ageboundyounger,
		chr.agemodel,
    chr.notes,
	chr.chronologyid,
    chr.dateprepared
$function$
