-- Function: public.fn_rmt_container_owners(integer)

-- DROP FUNCTION public.fn_rmt_container_owners(integer);

CREATE OR REPLACE FUNCTION public.fn_rmt_container_owners(in_id integer)
  RETURNS text AS
$BODY$
  SELECT COALESCE(o.short_description ||' - ' || r.name, p.first_name || ' ' || p.surname ||' - ' || r.name) AS party_name
  FROM party_roles pr
  LEFT OUTER JOIN organizations o ON o.id = pr.organization_id
  LEFT OUTER JOIN people p ON p.id = pr.person_id
  LEFT OUTER JOIN roles r ON r.id = pr.role_id
  WHERE pr.id = in_id
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.fn_rmt_container_owners(integer)
  OWNER TO postgres;
