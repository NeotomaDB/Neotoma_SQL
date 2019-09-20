CREATE OR REPLACE FUNCTION ap.getdeptenvtypes(_depenvtid integer)
 RETURNS TABLE(depenvtid integer, depenvt character varying, children integer)
 LANGUAGE sql
AS $function$

    WITH
    nodes AS (
        select det.depenvtid, det.depenvthigherid, det.depenvt
        from ndb.depenvttypes as det 
        where det.depenvthigherid = _depenvtid and det.depenvtid != _depenvtid
    ),
    -- site info needed by the web application
    children as (
        select det.depenvthigherid, count(det.depenvtid)::integer as "children"
        from ndb.depenvttypes as det 
        where det.depenvthigherid in (select depenvtid from nodes)
        group by depenvthigherid
    )

    select n.depenvtid, n.depenvt, c.children
    from nodes as n left join
    children as c on n.depenvtid = c.depenvthigherid

$function$
