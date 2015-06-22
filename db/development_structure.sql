--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: intbig_gkey; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE intbig_gkey;


--
-- Name: _intbig_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _intbig_in(cstring) RETURNS intbig_gkey
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_intbig_in';


--
-- Name: _intbig_out(intbig_gkey); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _intbig_out(intbig_gkey) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_intbig_out';


--
-- Name: intbig_gkey; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE intbig_gkey (
    INTERNALLENGTH = variable,
    INPUT = _intbig_in,
    OUTPUT = _intbig_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


--
-- Name: query_int; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE query_int;


--
-- Name: bqarr_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bqarr_in(cstring) RETURNS query_int
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'bqarr_in';


--
-- Name: bqarr_out(query_int); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bqarr_out(query_int) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'bqarr_out';


--
-- Name: query_int; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE query_int (
    INTERNALLENGTH = variable,
    INPUT = bqarr_in,
    OUTPUT = bqarr_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


--
-- Name: _int_contained(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_contained(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_contained';


--
-- Name: FUNCTION _int_contained(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_contained(integer[], integer[]) IS 'contained in';


--
-- Name: _int_contains(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_contains(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_contains';


--
-- Name: FUNCTION _int_contains(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_contains(integer[], integer[]) IS 'contains';


--
-- Name: _int_different(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_different(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_different';


--
-- Name: FUNCTION _int_different(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_different(integer[], integer[]) IS 'different';


--
-- Name: _int_inter(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_inter(integer[], integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_inter';


--
-- Name: _int_overlap(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_overlap(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_overlap';


--
-- Name: FUNCTION _int_overlap(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_overlap(integer[], integer[]) IS 'overlaps';


--
-- Name: _int_same(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_same(integer[], integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_same';


--
-- Name: FUNCTION _int_same(integer[], integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION _int_same(integer[], integer[]) IS 'same as';


--
-- Name: _int_union(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _int_union(integer[], integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', '_int_union';


--
-- Name: addgeometrycolumn(character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT AddGeometryColumn('','',$1,$2,$3,$4,$5) into ret;
	RETURN ret;
END;
$_$;


--
-- Name: addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STABLE STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT AddGeometryColumn('',$1,$2,$3,$4,$5,$6) into ret;
	RETURN ret;
END;
$_$;


--
-- Name: addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	new_srid alias for $5;
	new_type alias for $6;
	new_dim alias for $7;
	rec RECORD;
	sr varchar;
	real_schema name;
	sql text;

BEGIN

	-- Verify geometry type
	IF ( NOT ( (new_type = 'GEOMETRY') OR
			   (new_type = 'GEOMETRYCOLLECTION') OR
			   (new_type = 'POINT') OR
			   (new_type = 'MULTIPOINT') OR
			   (new_type = 'POLYGON') OR
			   (new_type = 'MULTIPOLYGON') OR
			   (new_type = 'LINESTRING') OR
			   (new_type = 'MULTILINESTRING') OR
			   (new_type = 'GEOMETRYCOLLECTIONM') OR
			   (new_type = 'POINTM') OR
			   (new_type = 'MULTIPOINTM') OR
			   (new_type = 'POLYGONM') OR
			   (new_type = 'MULTIPOLYGONM') OR
			   (new_type = 'LINESTRINGM') OR
			   (new_type = 'MULTILINESTRINGM') OR
			   (new_type = 'CIRCULARSTRING') OR
			   (new_type = 'CIRCULARSTRINGM') OR
			   (new_type = 'COMPOUNDCURVE') OR
			   (new_type = 'COMPOUNDCURVEM') OR
			   (new_type = 'CURVEPOLYGON') OR
			   (new_type = 'CURVEPOLYGONM') OR
			   (new_type = 'MULTICURVE') OR
			   (new_type = 'MULTICURVEM') OR
			   (new_type = 'MULTISURFACE') OR
			   (new_type = 'MULTISURFACEM')) )
	THEN
		RAISE EXCEPTION 'Invalid type name - valid ones are:
	POINT, MULTIPOINT,
	LINESTRING, MULTILINESTRING,
	POLYGON, MULTIPOLYGON,
	CIRCULARSTRING, COMPOUNDCURVE, MULTICURVE,
	CURVEPOLYGON, MULTISURFACE,
	GEOMETRY, GEOMETRYCOLLECTION,
	POINTM, MULTIPOINTM,
	LINESTRINGM, MULTILINESTRINGM,
	POLYGONM, MULTIPOLYGONM,
	CIRCULARSTRINGM, COMPOUNDCURVEM, MULTICURVEM
	CURVEPOLYGONM, MULTISURFACEM,
	or GEOMETRYCOLLECTIONM';
		RETURN 'fail';
	END IF;


	-- Verify dimension
	IF ( (new_dim >4) OR (new_dim <0) ) THEN
		RAISE EXCEPTION 'invalid dimension';
		RETURN 'fail';
	END IF;

	IF ( (new_type LIKE '%M') AND (new_dim!=3) ) THEN
		RAISE EXCEPTION 'TypeM needs 3 dimensions';
		RETURN 'fail';
	END IF;


	-- Verify SRID
	IF ( new_srid != -1 ) THEN
		SELECT SRID INTO sr FROM spatial_ref_sys WHERE SRID = new_srid;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'AddGeometryColumns() - invalid SRID';
			RETURN 'fail';
		END IF;
	END IF;


	-- Verify schema
	IF ( schema_name IS NOT NULL AND schema_name != '' ) THEN
		sql := 'SELECT nspname FROM pg_namespace ' ||
			'WHERE text(nspname) = ' || quote_literal(schema_name) ||
			'LIMIT 1';
		RAISE DEBUG '%', sql;
		EXECUTE sql INTO real_schema;

		IF ( real_schema IS NULL ) THEN
			RAISE EXCEPTION 'Schema % is not a valid schemaname', quote_literal(schema_name);
			RETURN 'fail';
		END IF;
	END IF;

	IF ( real_schema IS NULL ) THEN
		RAISE DEBUG 'Detecting schema';
		sql := 'SELECT n.nspname AS schemaname ' ||
			'FROM pg_catalog.pg_class c ' ||
			  'JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace ' ||
			'WHERE c.relkind = ' || quote_literal('r') ||
			' AND n.nspname NOT IN (' || quote_literal('pg_catalog') || ', ' || quote_literal('pg_toast') || ')' ||
			' AND pg_catalog.pg_table_is_visible(c.oid)' ||
			' AND c.relname = ' || quote_literal(table_name);
		RAISE DEBUG '%', sql;
		EXECUTE sql INTO real_schema;

		IF ( real_schema IS NULL ) THEN
			RAISE EXCEPTION 'Table % does not occur in the search_path', quote_literal(table_name);
			RETURN 'fail';
		END IF;
	END IF;


	-- Add geometry column to table
	sql := 'ALTER TABLE ' ||
		quote_ident(real_schema) || '.' || quote_ident(table_name)
		|| ' ADD COLUMN ' || quote_ident(column_name) ||
		' geometry ';
	RAISE DEBUG '%', sql;
	EXECUTE sql;


	-- Delete stale record in geometry_columns (if any)
	sql := 'DELETE FROM geometry_columns WHERE
		f_table_catalog = ' || quote_literal('') ||
		' AND f_table_schema = ' ||
		quote_literal(real_schema) ||
		' AND f_table_name = ' || quote_literal(table_name) ||
		' AND f_geometry_column = ' || quote_literal(column_name);
	RAISE DEBUG '%', sql;
	EXECUTE sql;


	-- Add record in geometry_columns
	sql := 'INSERT INTO geometry_columns (f_table_catalog,f_table_schema,f_table_name,' ||
										  'f_geometry_column,coord_dimension,srid,type)' ||
		' VALUES (' ||
		quote_literal('') || ',' ||
		quote_literal(real_schema) || ',' ||
		quote_literal(table_name) || ',' ||
		quote_literal(column_name) || ',' ||
		new_dim::text || ',' ||
		new_srid::text || ',' ||
		quote_literal(new_type) || ')';
	RAISE DEBUG '%', sql;
	EXECUTE sql;


	-- Add table CHECKs
	sql := 'ALTER TABLE ' ||
		quote_ident(real_schema) || '.' || quote_ident(table_name)
		|| ' ADD CONSTRAINT '
		|| quote_ident('enforce_srid_' || column_name)
		|| ' CHECK (ST_SRID(' || quote_ident(column_name) ||
		') = ' || new_srid::text || ')' ;
	RAISE DEBUG '%', sql;
	EXECUTE sql;

	sql := 'ALTER TABLE ' ||
		quote_ident(real_schema) || '.' || quote_ident(table_name)
		|| ' ADD CONSTRAINT '
		|| quote_ident('enforce_dims_' || column_name)
		|| ' CHECK (ST_NDims(' || quote_ident(column_name) ||
		') = ' || new_dim::text || ')' ;
	RAISE DEBUG '%', sql;
	EXECUTE sql;

	IF ( NOT (new_type = 'GEOMETRY')) THEN
		sql := 'ALTER TABLE ' ||
			quote_ident(real_schema) || '.' || quote_ident(table_name) || ' ADD CONSTRAINT ' ||
			quote_ident('enforce_geotype_' || column_name) ||
			' CHECK (GeometryType(' ||
			quote_ident(column_name) || ')=' ||
			quote_literal(new_type) || ' OR (' ||
			quote_ident(column_name) || ') is null)';
		RAISE DEBUG '%', sql;
		EXECUTE sql;
	END IF;

	RETURN
		real_schema || '.' ||
		table_name || '.' || column_name ||
		' SRID:' || new_srid::text ||
		' TYPE:' || new_type ||
		' DIMS:' || new_dim::text || ' ';
END;
$_$;


--
-- Name: affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)$_$;


--
-- Name: asgml(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION asgml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0)$_$;


--
-- Name: asgml(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION asgml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0)$_$;


--
-- Name: askml(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION askml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, transform($1,4326), 15)$_$;


--
-- Name: askml(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION askml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, transform($1,4326), $2)$_$;


--
-- Name: askml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION askml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, transform($2,4326), $3)$_$;


--
-- Name: bdmpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bdmpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := multi(BuildArea(mline));

	RETURN geom;
END;
$_$;


--
-- Name: bdpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION bdpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := BuildArea(mline);

	IF GeometryType(geom) != 'POLYGON'
	THEN
		RAISE EXCEPTION 'Input returns more then a single polygon, try using BdMPolyFromText instead';
	END IF;

	RETURN geom;
END;
$_$;


--
-- Name: boolop(integer[], query_int); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION boolop(integer[], query_int) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'boolop';


--
-- Name: FUNCTION boolop(integer[], query_int); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION boolop(integer[], query_int) IS 'boolean operation with array';


--
-- Name: buffer(geometry, double precision, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION buffer(geometry, double precision, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Buffer($1, $2, $3)$_$;


--
-- Name: find_extent(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION find_extent(text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	tablename alias for $1;
	columnname alias for $2;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT extent("' || columnname || '") FROM "' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


--
-- Name: find_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION find_extent(text, text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	schemaname alias for $1;
	tablename alias for $2;
	columnname alias for $3;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT extent("' || columnname || '") FROM "' || schemaname || '"."' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


--
-- Name: fix_geometry_columns(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fix_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	mislinked record;
	result text;
	linked integer;
	deleted integer;
	foundschema integer;
BEGIN

	-- Since 7.3 schema support has been added.
	-- Previous postgis versions used to put the database name in
	-- the schema column. This needs to be fixed, so we try to
	-- set the correct schema for each geometry_colums record
	-- looking at table, column, type and srid.
	UPDATE geometry_columns SET f_table_schema = n.nspname
		FROM pg_namespace n, pg_class c, pg_attribute a,
			pg_constraint sridcheck, pg_constraint typecheck
			WHERE ( f_table_schema is NULL
		OR f_table_schema = ''
			OR f_table_schema NOT IN (
					SELECT nspname::varchar
					FROM pg_namespace nn, pg_class cc, pg_attribute aa
					WHERE cc.relnamespace = nn.oid
					AND cc.relname = f_table_name::name
					AND aa.attrelid = cc.oid
					AND aa.attname = f_geometry_column::name))
			AND f_table_name::name = c.relname
			AND c.oid = a.attrelid
			AND c.relnamespace = n.oid
			AND f_geometry_column::name = a.attname

			AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE '(srid(% = %)'
			AND sridcheck.consrc ~ textcat(' = ', srid::text)

			AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
		'((geometrytype(%) = ''%''::text) OR (% IS NULL))'
			AND typecheck.consrc ~ textcat(' = ''', type::text)

			AND NOT EXISTS (
					SELECT oid FROM geometry_columns gc
					WHERE c.relname::varchar = gc.f_table_name
					AND n.nspname::varchar = gc.f_table_schema
					AND a.attname::varchar = gc.f_geometry_column
			);

	GET DIAGNOSTICS foundschema = ROW_COUNT;

	-- no linkage to system table needed
	return 'fixed:'||foundschema::text;

END;
$$;


--
-- Name: g_int_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_compress';


--
-- Name: g_int_consistent(internal, integer[], integer, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_consistent(internal, integer[], integer, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_consistent';


--
-- Name: g_int_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_decompress';


--
-- Name: g_int_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_penalty';


--
-- Name: g_int_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_picksplit';


--
-- Name: g_int_same(integer[], integer[], internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_same(integer[], integer[], internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_same';


--
-- Name: g_int_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_int_union(internal, internal) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_int_union';


--
-- Name: g_intbig_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_compress';


--
-- Name: g_intbig_consistent(internal, internal, integer, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_consistent(internal, internal, integer, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_consistent';


--
-- Name: g_intbig_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_decompress';


--
-- Name: g_intbig_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_penalty';


--
-- Name: g_intbig_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_picksplit';


--
-- Name: g_intbig_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_same';


--
-- Name: g_intbig_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION g_intbig_union(internal, internal) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'g_intbig_union';


--
-- Name: geomcollfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomcollfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


--
-- Name: geomcollfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomcollfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


--
-- Name: geomcollfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomcollfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: geomcollfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomcollfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: geomfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geometryfromtext($1)$_$;


--
-- Name: geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geometryfromtext($1, $2)$_$;


--
-- Name: geomfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION geomfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT setSRID(GeomFromWKB($1), $2)$_$;


--
-- Name: ginint4_consistent(internal, smallint, internal, integer, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ginint4_consistent(internal, smallint, internal, integer, internal, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'ginint4_consistent';


--
-- Name: ginint4_queryextract(internal, internal, smallint, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ginint4_queryextract(internal, internal, smallint, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'ginint4_queryextract';


--
-- Name: icount(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION icount(integer[]) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'icount';


--
-- Name: idx(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION idx(integer[], integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'idx';


--
-- Name: intarray_del_elem(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intarray_del_elem(integer[], integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intarray_del_elem';


--
-- Name: intarray_push_array(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intarray_push_array(integer[], integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intarray_push_array';


--
-- Name: intarray_push_elem(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intarray_push_elem(integer[], integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intarray_push_elem';


--
-- Name: intset(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intset(integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intset';


--
-- Name: intset_subtract(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intset_subtract(integer[], integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intset_subtract';


--
-- Name: intset_union_elem(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION intset_union_elem(integer[], integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'intset_union_elem';


--
-- Name: linefromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'LINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


--
-- Name: linefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'LINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


--
-- Name: linefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: linefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: linestringfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1)$_$;


--
-- Name: linestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1, $2)$_$;


--
-- Name: linestringfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linestringfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: linestringfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION linestringfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: locate_along_measure(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION locate_along_measure(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT locate_between_measures($1, $2, $2) $_$;


--
-- Name: mlinefromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mlinefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTILINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


--
-- Name: mlinefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mlinefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


--
-- Name: mlinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mlinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: mlinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mlinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: mpointfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


--
-- Name: mpointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1,$2)) = 'MULTIPOINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


--
-- Name: mpointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: mpointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: mpolyfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpolyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


--
-- Name: mpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


--
-- Name: mpolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: mpolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mpolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: multilinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multilinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: multilinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multilinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: multilinestringfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multilinestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MLineFromText($1)$_$;


--
-- Name: multilinestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multilinestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MLineFromText($1, $2)$_$;


--
-- Name: multipointfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1)$_$;


--
-- Name: multipointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1, $2)$_$;


--
-- Name: multipointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: multipointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: multipolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: multipolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: multipolygonfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipolygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1)$_$;


--
-- Name: multipolygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION multipolygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1, $2)$_$;


--
-- Name: pointfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


--
-- Name: pointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


--
-- Name: pointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: pointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'POINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: polyfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


--
-- Name: polyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


--
-- Name: polyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: polyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: polygonfromtext(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1)$_$;


--
-- Name: polygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1, $2)$_$;


--
-- Name: polygonfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polygonfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


--
-- Name: polygonfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION polygonfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


--
-- Name: populate_geometry_columns(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION populate_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	inserted    integer;
	oldcount    integer;
	probed      integer;
	stale       integer;
	gcs         RECORD;
	gc          RECORD;
	gsrid       integer;
	gndims      integer;
	gtype       text;
	query       text;
	gc_is_valid boolean;

BEGIN
	SELECT count(*) INTO oldcount FROM geometry_columns;
	inserted := 0;

	EXECUTE 'TRUNCATE geometry_columns';

	-- Count the number of geometry columns in all tables and views
	SELECT count(DISTINCT c.oid) INTO probed
	FROM pg_class c,
		 pg_attribute a,
		 pg_type t,
		 pg_namespace n
	WHERE (c.relkind = 'r' OR c.relkind = 'v')
	AND t.typname = 'geometry'
	AND a.attisdropped = false
	AND a.atttypid = t.oid
	AND a.attrelid = c.oid
	AND c.relnamespace = n.oid
	AND n.nspname NOT ILIKE 'pg_temp%';

	-- Iterate through all non-dropped geometry columns
	RAISE DEBUG 'Processing Tables.....';

	FOR gcs IN
	SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'r'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
	LOOP

	inserted := inserted + populate_geometry_columns(gcs.oid);
	END LOOP;

	-- Add views to geometry columns table
	RAISE DEBUG 'Processing Views.....';
	FOR gcs IN
	SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'v'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
	LOOP

	inserted := inserted + populate_geometry_columns(gcs.oid);
	END LOOP;

	IF oldcount > inserted THEN
	stale = oldcount-inserted;
	ELSE
	stale = 0;
	END IF;

	RETURN 'probed:' ||probed|| ' inserted:'||inserted|| ' conflicts:'||probed-inserted|| ' deleted:'||stale;
END

$$;


--
-- Name: populate_geometry_columns(oid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION populate_geometry_columns(tbl_oid oid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	gcs         RECORD;
	gc          RECORD;
	gsrid       integer;
	gndims      integer;
	gtype       text;
	query       text;
	gc_is_valid boolean;
	inserted    integer;

BEGIN
	inserted := 0;

	-- Iterate through all geometry columns in this table
	FOR gcs IN
	SELECT n.nspname, c.relname, a.attname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'r'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
		AND c.oid = tbl_oid
	LOOP

	RAISE DEBUG 'Processing table %.%.%', gcs.nspname, gcs.relname, gcs.attname;

	DELETE FROM geometry_columns
	  WHERE f_table_schema = quote_ident(gcs.nspname)
	  AND f_table_name = quote_ident(gcs.relname)
	  AND f_geometry_column = quote_ident(gcs.attname);

	gc_is_valid := true;

	-- Try to find srid check from system tables (pg_constraint)
	gsrid :=
		(SELECT replace(replace(split_part(s.consrc, ' = ', 2), ')', ''), '(', '')
		 FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
		 WHERE n.nspname = gcs.nspname
		 AND c.relname = gcs.relname
		 AND a.attname = gcs.attname
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%srid(% = %');
	IF (gsrid IS NULL) THEN
		-- Try to find srid from the geometry itself
		EXECUTE 'SELECT srid(' || quote_ident(gcs.attname) || ')
				 FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gsrid := gc.srid;

		-- Try to apply srid check to column
		IF (gsrid IS NOT NULL) THEN
			BEGIN
				EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
						 ADD CONSTRAINT ' || quote_ident('enforce_srid_' || gcs.attname) || '
						 CHECK (srid(' || quote_ident(gcs.attname) || ') = ' || gsrid || ')';
			EXCEPTION
				WHEN check_violation THEN
					RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (srid(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gsrid;
					gc_is_valid := false;
			END;
		END IF;
	END IF;

	-- Try to find ndims check from system tables (pg_constraint)
	gndims :=
		(SELECT replace(split_part(s.consrc, ' = ', 2), ')', '')
		 FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
		 WHERE n.nspname = gcs.nspname
		 AND c.relname = gcs.relname
		 AND a.attname = gcs.attname
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%ndims(% = %');
	IF (gndims IS NULL) THEN
		-- Try to find ndims from the geometry itself
		EXECUTE 'SELECT ndims(' || quote_ident(gcs.attname) || ')
				 FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gndims := gc.ndims;

		-- Try to apply ndims check to column
		IF (gndims IS NOT NULL) THEN
			BEGIN
				EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
						 ADD CONSTRAINT ' || quote_ident('enforce_dims_' || gcs.attname) || '
						 CHECK (ndims(' || quote_ident(gcs.attname) || ') = '||gndims||')';
			EXCEPTION
				WHEN check_violation THEN
					RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (ndims(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gndims;
					gc_is_valid := false;
			END;
		END IF;
	END IF;

	-- Try to find geotype check from system tables (pg_constraint)
	gtype :=
		(SELECT replace(split_part(s.consrc, '''', 2), ')', '')
		 FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
		 WHERE n.nspname = gcs.nspname
		 AND c.relname = gcs.relname
		 AND a.attname = gcs.attname
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%geometrytype(% = %');
	IF (gtype IS NULL) THEN
		-- Try to find geotype from the geometry itself
		EXECUTE 'SELECT geometrytype(' || quote_ident(gcs.attname) || ')
				 FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gtype := gc.geometrytype;
		--IF (gtype IS NULL) THEN
		--    gtype := 'GEOMETRY';
		--END IF;

		-- Try to apply geometrytype check to column
		IF (gtype IS NOT NULL) THEN
			BEGIN
				EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				ADD CONSTRAINT ' || quote_ident('enforce_geotype_' || gcs.attname) || '
				CHECK ((geometrytype(' || quote_ident(gcs.attname) || ') = ' || quote_literal(gtype) || ') OR (' || quote_ident(gcs.attname) || ' IS NULL))';
			EXCEPTION
				WHEN check_violation THEN
					-- No geometry check can be applied. This column contains a number of geometry types.
					RAISE WARNING 'Could not add geometry type check (%) to table column: %.%.%', gtype, quote_ident(gcs.nspname),quote_ident(gcs.relname),quote_ident(gcs.attname);
			END;
		END IF;
	END IF;

	IF (gsrid IS NULL) THEN
		RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the srid', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
	ELSIF (gndims IS NULL) THEN
		RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the number of dimensions', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
	ELSIF (gtype IS NULL) THEN
		RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the geometry type', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
	ELSE
		-- Only insert into geometry_columns if table constraints could be applied.
		IF (gc_is_valid) THEN
			INSERT INTO geometry_columns (f_table_catalog,f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
			VALUES ('', gcs.nspname, gcs.relname, gcs.attname, gndims, gsrid, gtype);
			inserted := inserted + 1;
		END IF;
	END IF;
	END LOOP;

	-- Add views to geometry columns table
	FOR gcs IN
	SELECT n.nspname, c.relname, a.attname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'v'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
		AND c.oid = tbl_oid
	LOOP
		RAISE DEBUG 'Processing view %.%.%', gcs.nspname, gcs.relname, gcs.attname;

		EXECUTE 'SELECT ndims(' || quote_ident(gcs.attname) || ')
				 FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gndims := gc.ndims;

		EXECUTE 'SELECT srid(' || quote_ident(gcs.attname) || ')
				 FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gsrid := gc.srid;

		EXECUTE 'SELECT geometrytype(' || quote_ident(gcs.attname) || ')
				 FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gtype := gc.geometrytype;

		IF (gndims IS NULL) THEN
			RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine ndims', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
		ELSIF (gsrid IS NULL) THEN
			RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine srid', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
		ELSIF (gtype IS NULL) THEN
			RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine gtype', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
		ELSE
			query := 'INSERT INTO geometry_columns (f_table_catalog,f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) ' ||
					 'VALUES ('''', ' || quote_literal(gcs.nspname) || ',' || quote_literal(gcs.relname) || ',' || quote_literal(gcs.attname) || ',' || gndims || ',' || gsrid || ',' || quote_literal(gtype) || ')';
			EXECUTE query;
			inserted := inserted + 1;
		END IF;
	END LOOP;

	RETURN inserted;
END

$$;


--
-- Name: probe_geometry_columns(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION probe_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	inserted integer;
	oldcount integer;
	probed integer;
	stale integer;
BEGIN

	SELECT count(*) INTO oldcount FROM geometry_columns;

	SELECT count(*) INTO probed
		FROM pg_class c, pg_attribute a, pg_type t,
			pg_namespace n,
			pg_constraint sridcheck, pg_constraint typecheck

		WHERE t.typname = 'geometry'
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND sridcheck.connamespace = n.oid
		AND typecheck.connamespace = n.oid
		AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE '(srid('||a.attname||') = %)'
		AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
		'((geometrytype('||a.attname||') = ''%''::text) OR (% IS NULL))'
		;

	INSERT INTO geometry_columns SELECT
		''::varchar as f_table_catalogue,
		n.nspname::varchar as f_table_schema,
		c.relname::varchar as f_table_name,
		a.attname::varchar as f_geometry_column,
		2 as coord_dimension,
		trim(both  ' =)' from
			replace(replace(split_part(
				sridcheck.consrc, ' = ', 2), ')', ''), '(', ''))::integer AS srid,
		trim(both ' =)''' from substr(typecheck.consrc,
			strpos(typecheck.consrc, '='),
			strpos(typecheck.consrc, '::')-
			strpos(typecheck.consrc, '=')
			))::varchar as type
		FROM pg_class c, pg_attribute a, pg_type t,
			pg_namespace n,
			pg_constraint sridcheck, pg_constraint typecheck
		WHERE t.typname = 'geometry'
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND sridcheck.connamespace = n.oid
		AND typecheck.connamespace = n.oid
		AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE '(st_srid('||a.attname||') = %)'
		AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
		'((geometrytype('||a.attname||') = ''%''::text) OR (% IS NULL))'

			AND NOT EXISTS (
					SELECT oid FROM geometry_columns gc
					WHERE c.relname::varchar = gc.f_table_name
					AND n.nspname::varchar = gc.f_table_schema
					AND a.attname::varchar = gc.f_geometry_column
			);

	GET DIAGNOSTICS inserted = ROW_COUNT;

	IF oldcount > probed THEN
		stale = oldcount-probed;
	ELSE
		stale = 0;
	END IF;

	RETURN 'probed:'||probed::text||
		' inserted:'||inserted::text||
		' conflicts:'||(probed-inserted)::text||
		' stale:'||stale::text;
END

$$;


--
-- Name: querytree(query_int); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION querytree(query_int) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'querytree';


--
-- Name: rboolop(query_int, integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rboolop(query_int, integer[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'rboolop';


--
-- Name: FUNCTION rboolop(query_int, integer[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION rboolop(query_int, integer[]) IS 'boolean operation with array';


--
-- Name: rename_geometry_table_constraints(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rename_geometry_table_constraints() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT 'rename_geometry_table_constraint() is obsoleted'::text
$$;


--
-- Name: rotate(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rotate(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT rotateZ($1, $2)$_$;


--
-- Name: rotatex(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rotatex(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)$_$;


--
-- Name: rotatey(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rotatey(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)$_$;


--
-- Name: rotatez(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rotatez(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)$_$;


--
-- Name: scale(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION scale(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT scale($1, $2, $3, 1)$_$;


--
-- Name: scale(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION scale(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $2, 0, 0,  0, $3, 0,  0, 0, $4,  0, 0, 0)$_$;


--
-- Name: se_envelopesintersect(geometry, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION se_envelopesintersect(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
	SELECT $1 && $2
	$_$;


--
-- Name: se_locatealong(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION se_locatealong(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT locate_between_measures($1, $2, $2) $_$;


--
-- Name: snaptogrid(geometry, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION snaptogrid(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT SnapToGrid($1, 0, 0, $2, $2)$_$;


--
-- Name: snaptogrid(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION snaptogrid(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT SnapToGrid($1, 0, 0, $2, $3)$_$;


--
-- Name: somefunc(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION somefunc() RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE
    quantity integer := 30;
    BEGIN
        RAISE NOTICE 'Quantity here is %', quantity;  -- Prints 30
	    quantity := 50;
	        --
		    -- Create a subblock
		        --
			    DECLARE
			            quantity integer := 80;
				        BEGIN
					        RAISE NOTICE 'Quantity here is %', quantity;  -- Prints 80
						        RAISE NOTICE 'Outer quantity here is %', outerblock.quantity;  -- Prints 50
							    END;

							        RAISE NOTICE 'Quantity here is %', quantity;  -- Prints 50

								    RETURN quantity;
								    END;
								    $$;


--
-- Name: sort(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sort(integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'sort';


--
-- Name: sort(integer[], text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sort(integer[], text) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'sort';


--
-- Name: sort_asc(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sort_asc(integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'sort_asc';


--
-- Name: sort_desc(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sort_desc(integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'sort_desc';


--
-- Name: st_area(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_area(geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Area($1, true)$_$;


--
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);  $_$;


--
-- Name: st_asgeojson(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, 15, 0)$_$;


--
-- Name: st_asgeojson(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, 15, 0)$_$;


--
-- Name: st_asgeojson(integer, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(integer, geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, 15, 0)$_$;


--
-- Name: st_asgeojson(integer, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(integer, geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, 15, 0)$_$;


--
-- Name: st_asgeojson(geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, $2, 0)$_$;


--
-- Name: st_asgeojson(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, $2, 0)$_$;


--
-- Name: st_asgeojson(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(integer, geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, $3, 0)$_$;


--
-- Name: st_asgeojson(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgeojson(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, $3, 0)$_$;


--
-- Name: st_asgml(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0)$_$;


--
-- Name: st_asgml(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0)$_$;


--
-- Name: st_asgml(integer, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, 15, 0)$_$;


--
-- Name: st_asgml(integer, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, 15, 0)$_$;


--
-- Name: st_asgml(geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0)$_$;


--
-- Name: st_asgml(geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0)$_$;


--
-- Name: st_asgml(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, 0)$_$;


--
-- Name: st_asgml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, 0)$_$;


--
-- Name: st_asgml(integer, geography, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geography, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, $4)$_$;


--
-- Name: st_asgml(integer, geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_asgml(integer, geometry, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, $4)$_$;


--
-- Name: st_askml(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, $1, 15)$_$;


--
-- Name: st_askml(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_Transform($1,4326), 15)$_$;


--
-- Name: st_askml(integer, geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(integer, geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, $2, 15)$_$;


--
-- Name: st_askml(integer, geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(integer, geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, ST_Transform($2,4326), 15)$_$;


--
-- Name: st_askml(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(integer, geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, $2, $3)$_$;


--
-- Name: st_askml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_askml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, ST_Transform($2,4326), $3)$_$;


--
-- Name: st_geohash(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_geohash(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeoHash($1, 0)$_$;


--
-- Name: st_length(geography); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_length(geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT ST_Length($1, true)$_$;


--
-- Name: st_minimumboundingcircle(geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION st_minimumboundingcircle(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MinimumBoundingCircle($1, 48)$_$;


--
-- Name: subarray(integer[], integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subarray(integer[], integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'subarray';


--
-- Name: subarray(integer[], integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subarray(integer[], integer, integer) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'subarray';


--
-- Name: translate(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION translate(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT translate($1, $2, $3, 0)$_$;


--
-- Name: translate(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION translate(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)$_$;


--
-- Name: transscale(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION transscale(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $4, 0, 0,  0, $5, 0,
		0, 0, 1,  $2 * $4, $3 * $5, 0)$_$;


--
-- Name: uniq(integer[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION uniq(integer[]) RETURNS integer[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/_int', 'uniq';


--
-- Name: accum(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE accum(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_accum_finalfn
);


--
-- Name: collect(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE collect(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_collect_finalfn
);


--
-- Name: makeline(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE makeline(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_makeline_finalfn
);


--
-- Name: memcollect(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE memcollect(geometry) (
    SFUNC = public.st_collect,
    STYPE = geometry
);


--
-- Name: polygonize(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE polygonize(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_polygonize_finalfn
);


--
-- Name: st_extent3d(geometry); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE st_extent3d(geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = box3d
);


--
-- Name: #; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR # (
    PROCEDURE = icount,
    RIGHTARG = integer[]
);


--
-- Name: #; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR # (
    PROCEDURE = idx,
    LEFTARG = integer[],
    RIGHTARG = integer
);


--
-- Name: &; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR & (
    PROCEDURE = _int_inter,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = &
);


--
-- Name: &&; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR && (
    PROCEDURE = _int_overlap,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = &&,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: +; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR + (
    PROCEDURE = intarray_push_elem,
    LEFTARG = integer[],
    RIGHTARG = integer
);


--
-- Name: +; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR + (
    PROCEDURE = intarray_push_array,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = +
);


--
-- Name: -; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR - (
    PROCEDURE = intarray_del_elem,
    LEFTARG = integer[],
    RIGHTARG = integer
);


--
-- Name: -; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR - (
    PROCEDURE = intset_subtract,
    LEFTARG = integer[],
    RIGHTARG = integer[]
);


--
-- Name: <@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <@ (
    PROCEDURE = _int_contained,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @ (
    PROCEDURE = _int_contains,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @> (
    PROCEDURE = _int_contains,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: @@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @@ (
    PROCEDURE = boolop,
    LEFTARG = integer[],
    RIGHTARG = query_int,
    COMMUTATOR = ~~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: |; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR | (
    PROCEDURE = intset_union_elem,
    LEFTARG = integer[],
    RIGHTARG = integer
);


--
-- Name: |; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR | (
    PROCEDURE = _int_union,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = |
);


--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = _int_contained,
    LEFTARG = integer[],
    RIGHTARG = integer[],
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: ~~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~~ (
    PROCEDURE = rboolop,
    LEFTARG = query_int,
    RIGHTARG = integer[],
    COMMUTATOR = @@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- Name: gin__int_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gin__int_ops
    FOR TYPE integer[] USING gin AS
    STORAGE integer ,
    OPERATOR 3 &&(integer[],integer[]) ,
    OPERATOR 6 =(anyarray,anyarray) ,
    OPERATOR 7 @>(integer[],integer[]) ,
    OPERATOR 8 <@(integer[],integer[]) ,
    OPERATOR 13 @(integer[],integer[]) ,
    OPERATOR 14 ~(integer[],integer[]) ,
    OPERATOR 20 @@(integer[],query_int) ,
    FUNCTION 1 (integer[], integer[]) btint4cmp(integer,integer) ,
    FUNCTION 2 (integer[], integer[]) ginarrayextract(anyarray,internal) ,
    FUNCTION 3 (integer[], integer[]) ginint4_queryextract(internal,internal,smallint,internal,internal) ,
    FUNCTION 4 (integer[], integer[]) ginint4_consistent(internal,smallint,internal,integer,internal,internal);


--
-- Name: gist__int_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist__int_ops
    DEFAULT FOR TYPE integer[] USING gist AS
    OPERATOR 3 &&(integer[],integer[]) ,
    OPERATOR 6 =(anyarray,anyarray) ,
    OPERATOR 7 @>(integer[],integer[]) ,
    OPERATOR 8 <@(integer[],integer[]) ,
    OPERATOR 13 @(integer[],integer[]) ,
    OPERATOR 14 ~(integer[],integer[]) ,
    OPERATOR 20 @@(integer[],query_int) ,
    FUNCTION 1 (integer[], integer[]) g_int_consistent(internal,integer[],integer,oid,internal) ,
    FUNCTION 2 (integer[], integer[]) g_int_union(internal,internal) ,
    FUNCTION 3 (integer[], integer[]) g_int_compress(internal) ,
    FUNCTION 4 (integer[], integer[]) g_int_decompress(internal) ,
    FUNCTION 5 (integer[], integer[]) g_int_penalty(internal,internal,internal) ,
    FUNCTION 6 (integer[], integer[]) g_int_picksplit(internal,internal) ,
    FUNCTION 7 (integer[], integer[]) g_int_same(integer[],integer[],internal);


--
-- Name: gist__intbig_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS gist__intbig_ops
    FOR TYPE integer[] USING gist AS
    STORAGE intbig_gkey ,
    OPERATOR 3 &&(integer[],integer[]) ,
    OPERATOR 6 =(anyarray,anyarray) ,
    OPERATOR 7 @>(integer[],integer[]) ,
    OPERATOR 8 <@(integer[],integer[]) ,
    OPERATOR 13 @(integer[],integer[]) ,
    OPERATOR 14 ~(integer[],integer[]) ,
    OPERATOR 20 @@(integer[],query_int) ,
    FUNCTION 1 (integer[], integer[]) g_intbig_consistent(internal,internal,integer,oid,internal) ,
    FUNCTION 2 (integer[], integer[]) g_intbig_union(internal,internal) ,
    FUNCTION 3 (integer[], integer[]) g_intbig_compress(internal) ,
    FUNCTION 4 (integer[], integer[]) g_intbig_decompress(internal) ,
    FUNCTION 5 (integer[], integer[]) g_intbig_penalty(internal,internal,internal) ,
    FUNCTION 6 (integer[], integer[]) g_intbig_picksplit(internal,internal) ,
    FUNCTION 7 (integer[], integer[]) g_intbig_same(internal,internal,internal);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: changes_history_records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE changes_history_records (
    id integer NOT NULL,
    user_id integer,
    "when" timestamp without time zone,
    how text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    what_id integer,
    what_type character varying(255),
    reviewed boolean DEFAULT false,
    who_email character varying(255),
    who_organization character varying(255)
);


--
-- Name: changes_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE changes_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: changes_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE changes_histories_id_seq OWNED BY changes_history_records.id;


--
-- Name: changes_history_records_copy; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE changes_history_records_copy (
    id integer NOT NULL,
    user_id integer,
    "when" timestamp without time zone,
    how text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    what_id integer,
    what_type character varying(255),
    reviewed boolean,
    who_email character varying(255),
    who_organization character varying(255)
);


--
-- Name: clusters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clusters (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: clusters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clusters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clusters_id_seq OWNED BY clusters.id;


--
-- Name: clusters_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clusters_projects (
    cluster_id integer,
    project_id integer
);


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE countries (
    id integer NOT NULL,
    name character varying(255),
    code character varying(255),
    the_geom geometry,
    wiki_url character varying(255),
    wiki_description text,
    iso2_code character varying(255),
    iso3_code character varying(255),
    center_lat double precision,
    center_lon double precision,
    the_geom_geojson text,
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((geometrytype(the_geom) = 'MULTIPOLYGON'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE countries_id_seq OWNED BY countries.id;


--
-- Name: countries_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE countries_projects (
    country_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: data_denormalization; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_denormalization (
    project_id integer,
    project_name character varying(2000),
    project_description text,
    organization_id integer,
    organization_name character varying(2000),
    end_date date,
    regions text,
    regions_ids integer[],
    countries text,
    countries_ids integer[],
    sectors text,
    sector_ids integer[],
    clusters text,
    cluster_ids integer[],
    donors_ids integer[],
    is_active boolean,
    site_id integer,
    created_at timestamp without time zone,
    start_date date
);


--
-- Name: data_export; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE data_export (
    project_id integer,
    project_name character varying(2000),
    project_description text,
    organization_id integer,
    organization_name character varying(2000),
    implementing_organization text,
    partner_organizations text,
    cross_cutting_issues text,
    start_date date,
    end_date date,
    budget double precision,
    target text,
    estimated_people_reached bigint,
    project_contact_person character varying(255),
    project_contact_email character varying(255),
    project_contact_phone_number character varying(255),
    activities text,
    intervention_id character varying(255),
    additional_information text,
    awardee_type character varying(255),
    date_provided date,
    date_updated date,
    project_contact_position character varying(255),
    project_website character varying(255),
    verbatim_location text,
    calculation_of_number_of_people_reached text,
    project_needs text,
    sectors text,
    clusters text,
    project_tags text,
    countries text,
    regions_level1 text,
    regions_level2 text,
    regions_level3 text
);


--
-- Name: donations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE donations (
    id integer NOT NULL,
    donor_id integer,
    project_id integer,
    amount double precision,
    date date,
    office_id integer
);


--
-- Name: donations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE donations_id_seq OWNED BY donations.id;


--
-- Name: donors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE donors (
    id integer NOT NULL,
    name character varying(2000),
    description text,
    website character varying(255),
    twitter character varying(255),
    facebook character varying(255),
    contact_person_name character varying(255),
    contact_company character varying(255),
    contact_person_position character varying(255),
    contact_email character varying(255),
    contact_phone_number character varying(255),
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    site_specific_information text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: donors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE donors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE donors_id_seq OWNED BY donors.id;


--
-- Name: layer_styles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE layer_styles (
    id integer NOT NULL,
    title character varying(255),
    name character varying(255)
);


--
-- Name: layer_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE layer_styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: layer_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE layer_styles_id_seq OWNED BY layer_styles.id;


--
-- Name: layers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE layers (
    id integer NOT NULL,
    title character varying(255),
    description text,
    credits text,
    date timestamp without time zone,
    min double precision,
    max double precision,
    units character varying(255),
    status boolean,
    cartodb_table character varying(255),
    sql text,
    long_title character varying(255)
);


--
-- Name: layers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE layers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: layers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE layers_id_seq OWNED BY layers.id;


--
-- Name: media_resources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_resources (
    id integer NOT NULL,
    "position" integer DEFAULT 0,
    element_id integer,
    element_type integer,
    picture_file_name character varying(255),
    picture_content_type character varying(255),
    picture_filesize integer,
    picture_updated_at timestamp without time zone,
    video_url character varying(255),
    video_embed_html text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    caption character varying(255),
    video_thumb_file_name character varying(255),
    video_thumb_content_type character varying(255),
    video_thumb_file_size integer,
    video_thumb_updated_at timestamp without time zone
);


--
-- Name: media_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_resources_id_seq OWNED BY media_resources.id;


--
-- Name: offices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offices (
    id integer NOT NULL,
    donor_id integer,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: offices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE offices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE offices_id_seq OWNED BY offices.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name character varying(255),
    description text,
    budget double precision,
    website character varying(255),
    national_staff integer,
    twitter character varying(255),
    facebook character varying(255),
    hq_address character varying(255),
    contact_email character varying(255),
    contact_phone_number character varying(255),
    donation_address character varying(255),
    zip_code character varying(255),
    city character varying(255),
    state character varying(255),
    donation_phone_number character varying(255),
    donation_website character varying(255),
    site_specific_information text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    international_staff character varying(255),
    contact_name character varying(255),
    contact_position character varying(255),
    contact_zip character varying(255),
    contact_city character varying(255),
    contact_state character varying(255),
    contact_country character varying(255),
    donation_country character varying(255),
    estimated_people_reached integer,
    private_funding double precision,
    usg_funding double precision,
    other_funding double precision,
    private_funding_spent double precision,
    usg_funding_spent double precision,
    other_funding_spent double precision,
    spent_funding_on_relief double precision,
    spent_funding_on_reconstruction double precision,
    percen_relief integer,
    percen_reconstruction integer,
    media_contact_name character varying(255),
    media_contact_position character varying(255),
    media_contact_phone_number character varying(255),
    media_contact_email character varying(255),
    main_data_contact_name character varying(255),
    main_data_contact_position character varying(255),
    main_data_contact_phone_number character varying(255),
    main_data_contact_email character varying(255),
    main_data_contact_zip character varying(255),
    main_data_contact_city character varying(255),
    main_data_contact_state character varying(255),
    main_data_contact_country character varying(255),
    organization_id character varying(255)
);


--
-- Name: organizations2; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations2 (
    id integer NOT NULL,
    name character varying(255),
    description text,
    budget double precision,
    website character varying(255),
    national_staff integer,
    twitter character varying(255),
    facebook character varying(255),
    hq_address character varying(255),
    contact_email character varying(255),
    contact_phone_number character varying(255),
    donation_address character varying(255),
    zip_code character varying(255),
    city character varying(255),
    state character varying(255),
    donation_phone_number character varying(255),
    donation_website character varying(255),
    site_specific_information text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    international_staff character varying(255),
    contact_name character varying(255),
    contact_position character varying(255),
    contact_zip character varying(255),
    contact_city character varying(255),
    contact_state character varying(255),
    contact_country character varying(255),
    donation_country character varying(255),
    estimated_people_reached integer,
    private_funding double precision,
    usg_funding double precision,
    other_funding double precision,
    private_funding_spent double precision,
    usg_funding_spent double precision,
    other_funding_spent double precision,
    spent_funding_on_relief double precision,
    spent_funding_on_reconstruction double precision,
    percen_relief integer,
    percen_reconstruction integer,
    media_contact_name character varying(255),
    media_contact_position character varying(255),
    media_contact_phone_number character varying(255),
    media_contact_email character varying(255)
);


--
-- Name: organizations2_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations2_id_seq OWNED BY organizations2.id;


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: organizations_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations_projects (
    organization_id integer,
    project_id integer
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    title character varying(255),
    body text,
    site_id integer,
    published boolean,
    permalink character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    parent_id integer,
    order_index integer
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: partners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE partners (
    id integer NOT NULL,
    site_id integer,
    name character varying(255),
    url character varying(255),
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    label character varying(255)
);


--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE partners_id_seq OWNED BY partners.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying(2000),
    description text,
    primary_organization_id integer,
    implementing_organization text,
    partner_organizations text,
    cross_cutting_issues text,
    start_date date,
    end_date date,
    budget double precision,
    target text,
    estimated_people_reached bigint,
    contact_person character varying(255),
    contact_email character varying(255),
    contact_phone_number character varying(255),
    site_specific_information text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    the_geom geometry,
    activities text,
    intervention_id character varying(255),
    additional_information text,
    awardee_type character varying(255),
    date_provided date,
    date_updated date,
    contact_position character varying(255),
    website character varying(255),
    verbatim_location text,
    calculation_of_number_of_people_reached text,
    project_needs text,
    idprefugee_camp text,
    organization_id character varying(255),
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: projects_regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_regions (
    region_id integer,
    project_id integer
);


--
-- Name: projects_sectors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_sectors (
    sector_id integer,
    project_id integer
);


--
-- Name: projects_sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_sites (
    project_id integer,
    site_id integer
);


--
-- Name: projects_synchronizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_synchronizations (
    id integer NOT NULL,
    projects_file_data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: projects_synchronizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_synchronizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_synchronizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_synchronizations_id_seq OWNED BY projects_synchronizations.id;


--
-- Name: projects_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects_tags (
    tag_id integer,
    project_id integer
);


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE regions (
    id integer NOT NULL,
    name character varying(255),
    level integer,
    country_id integer,
    parent_region_id integer,
    the_geom geometry,
    gadm_id integer,
    wiki_url character varying(255),
    wiki_description text,
    code character varying(255),
    center_lat double precision,
    center_lon double precision,
    the_geom_geojson text,
    ia_name text,
    path character varying(255),
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE regions_id_seq OWNED BY regions.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resources (
    id integer NOT NULL,
    title character varying(255),
    url character varying(255),
    element_id integer,
    element_type integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_specific_information text
);


--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resources_id_seq OWNED BY resources.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sectors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sectors (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: sectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sectors_id_seq OWNED BY sectors.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE settings (
    id integer NOT NULL,
    data text
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE settings_id_seq OWNED BY settings.id;


--
-- Name: site_layers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE site_layers (
    site_id integer,
    layer_id integer,
    layer_style_id integer
);


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    name character varying(255),
    short_description text,
    long_description text,
    contact_email character varying(255),
    contact_person character varying(255),
    url character varying(255),
    permalink character varying(255),
    google_analytics_id character varying(255),
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    theme_id integer,
    blog_url character varying(255),
    word_for_clusters character varying(255),
    word_for_regions character varying(255),
    show_global_donations_raises boolean DEFAULT false,
    project_classification integer DEFAULT 0,
    geographic_context_country_id integer,
    geographic_context_region_id integer,
    project_context_cluster_id integer,
    project_context_sector_id integer,
    project_context_organization_id integer,
    project_context_tags character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    geographic_context_geometry geometry,
    project_context_tags_ids character varying(255),
    status boolean DEFAULT false,
    visits double precision DEFAULT 0,
    visits_last_week double precision DEFAULT 0,
    aid_map_image_file_name character varying(255),
    aid_map_image_content_type character varying(255),
    aid_map_image_file_size integer,
    aid_map_image_updated_at timestamp without time zone,
    navigate_by_country boolean DEFAULT false,
    navigate_by_level1 boolean DEFAULT false,
    navigate_by_level2 boolean DEFAULT false,
    navigate_by_level3 boolean DEFAULT false,
    map_styles text,
    overview_map_lat double precision,
    overview_map_lon double precision,
    overview_map_zoom integer,
    internal_description text,
    featured boolean DEFAULT false,
    CONSTRAINT enforce_dims_geographic_context_geometry CHECK ((st_ndims(geographic_context_geometry) = 2)),
    CONSTRAINT enforce_srid_geographic_context_geometry CHECK ((st_srid(geographic_context_geometry) = 4326))
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: stats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stats (
    id integer NOT NULL,
    site_id integer,
    visits integer,
    date date
);


--
-- Name: stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stats_id_seq OWNED BY stats.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255),
    count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: themes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE themes (
    id integer NOT NULL,
    name character varying(255),
    css_file character varying(255),
    thumbnail_path character varying(255),
    data text
);


--
-- Name: themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE themes_id_seq OWNED BY themes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(100) DEFAULT ''::character varying,
    email character varying(100),
    crypted_password character varying(40),
    salt character varying(40),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    remember_token character varying(40),
    remember_token_expires_at timestamp without time zone,
    organization_id integer,
    role character varying(255),
    blocked boolean DEFAULT false,
    site_id character varying(255),
    description text,
    password_reset_token character varying(255),
    password_reset_sent_at timestamp without time zone,
    last_login timestamp without time zone,
    six_months_since_last_login_alert_sent boolean DEFAULT false,
    login_fails integer DEFAULT 0
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: v_projects; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW v_projects AS
 SELECT p.id,
    p.primary_organization_id,
        CASE
            WHEN ((p.end_date < now()) OR (p.end_date IS NULL)) THEN false
            ELSE true
        END AS is_active,
    st_astext(p.the_geom) AS the_geom,
    (('|'::text || array_to_string(array_agg(DISTINCT projects_sites.site_id), '|'::text)) || '|'::text) AS sites,
    (('|'::text || array_to_string(array_agg(DISTINCT countries_projects.country_id), '|'::text)) || '|'::text) AS countries,
    (('|'::text || array_to_string(array_agg(DISTINCT clusters_projects.cluster_id), '|'::text)) || '|'::text) AS clusters,
    (('|'::text || array_to_string(array_agg(DISTINCT projects_tags.tag_id), '|'::text)) || '|'::text) AS tags,
    (('|'::text || array_to_string(array_agg(DISTINCT projects_sectors.sector_id), '|'::text)) || '|'::text) AS sectors,
    (('|'::text || ( SELECT array_to_string(array_agg(DISTINCT regions.name), ' | '::text) AS array_to_string
           FROM ((projects_regions
      RIGHT JOIN projects ON ((projects_regions.project_id = projects.id)))
   LEFT JOIN regions ON ((projects_regions.region_id = regions.id)))
  WHERE ((projects.id = p.id) AND (regions.level = 1)))) || '|'::text) AS regions_level1,
    (('|'::text || ( SELECT array_to_string(array_agg(DISTINCT regions.name), ' | '::text) AS array_to_string
           FROM ((projects_regions
      RIGHT JOIN projects ON ((projects_regions.project_id = projects.id)))
   LEFT JOIN regions ON ((projects_regions.region_id = regions.id)))
  WHERE ((projects.id = p.id) AND (regions.level = 2)))) || '|'::text) AS regions_level2,
    (('|'::text || ( SELECT array_to_string(array_agg(DISTINCT regions.name), ' | '::text) AS array_to_string
           FROM ((projects_regions
      RIGHT JOIN projects ON ((projects_regions.project_id = projects.id)))
   LEFT JOIN regions ON ((projects_regions.region_id = regions.id)))
  WHERE ((projects.id = p.id) AND (regions.level = 3)))) || '|'::text) AS regions_level3
   FROM (((((projects p
   LEFT JOIN projects_sectors ON ((p.id = projects_sectors.project_id)))
   LEFT JOIN clusters_projects ON ((p.id = clusters_projects.project_id)))
   LEFT JOIN countries_projects ON ((p.id = countries_projects.project_id)))
   LEFT JOIN projects_tags ON ((p.id = projects_tags.project_id)))
   LEFT JOIN projects_sites ON ((p.id = projects_sites.project_id)))
  GROUP BY p.id, p.primary_organization_id, p.start_date, p.end_date, p.the_geom;


--
-- Name: v_regions_num_projects; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW v_regions_num_projects AS
 SELECT r3.id AS region_id,
    r3.name,
    count(p.id) AS num_projects,
    st_astext(st_makepoint(r3.center_lon, r3.center_lat)) AS geom,
    ('http://haiti.ngoaidmap.org/location/'::text || (r3.path)::text) AS url
   FROM (((regions r3
   JOIN projects_regions pr ON ((r3.id = pr.region_id)))
   JOIN projects p ON ((pr.project_id = p.id)))
   JOIN projects_sites ps ON ((p.id = ps.project_id)))
  WHERE ((r3.level = 3) AND (ps.site_id = 1))
  GROUP BY r3.id, r3.name, st_astext(st_makepoint(r3.center_lon, r3.center_lat)), ('http://haiti.ngoaidmap.org/location/'::text || (r3.path)::text);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY changes_history_records ALTER COLUMN id SET DEFAULT nextval('changes_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clusters ALTER COLUMN id SET DEFAULT nextval('clusters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY donations ALTER COLUMN id SET DEFAULT nextval('donations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY donors ALTER COLUMN id SET DEFAULT nextval('donors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY layer_styles ALTER COLUMN id SET DEFAULT nextval('layer_styles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY layers ALTER COLUMN id SET DEFAULT nextval('layers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_resources ALTER COLUMN id SET DEFAULT nextval('media_resources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY offices ALTER COLUMN id SET DEFAULT nextval('offices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations2 ALTER COLUMN id SET DEFAULT nextval('organizations2_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY partners ALTER COLUMN id SET DEFAULT nextval('partners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects_synchronizations ALTER COLUMN id SET DEFAULT nextval('projects_synchronizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY regions ALTER COLUMN id SET DEFAULT nextval('regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resources ALTER COLUMN id SET DEFAULT nextval('resources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sectors ALTER COLUMN id SET DEFAULT nextval('sectors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stats ALTER COLUMN id SET DEFAULT nextval('stats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY themes ALTER COLUMN id SET DEFAULT nextval('themes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: changes_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY changes_history_records
    ADD CONSTRAINT changes_histories_pkey PRIMARY KEY (id);


--
-- Name: changes_history_records_copy_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY changes_history_records_copy
    ADD CONSTRAINT changes_history_records_copy_pkey PRIMARY KEY (id);


--
-- Name: clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clusters
    ADD CONSTRAINT clusters_pkey PRIMARY KEY (id);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: countries_projects_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY countries_projects
    ADD CONSTRAINT countries_projects_pk PRIMARY KEY (country_id, project_id);


--
-- Name: donations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
-- Name: donors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY donors
    ADD CONSTRAINT donors_pkey PRIMARY KEY (id);


--
-- Name: layer_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY layer_styles
    ADD CONSTRAINT layer_styles_pkey PRIMARY KEY (id);


--
-- Name: layers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY layers
    ADD CONSTRAINT layers_pkey PRIMARY KEY (id);


--
-- Name: media_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_resources
    ADD CONSTRAINT media_resources_pkey PRIMARY KEY (id);


--
-- Name: offices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id);


--
-- Name: organizations2_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations2
    ADD CONSTRAINT organizations2_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: partners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects_synchronizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects_synchronizations
    ADD CONSTRAINT projects_synchronizations_pkey PRIMARY KEY (id);


--
-- Name: regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: sectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: data_denormalization_cluster_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_cluster_idsx ON data_denormalization USING gist (cluster_ids);


--
-- Name: data_denormalization_countries_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_countries_idsx ON data_denormalization USING gist (countries_ids);


--
-- Name: data_denormalization_donors_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_donors_idsx ON data_denormalization USING gist (donors_ids);


--
-- Name: data_denormalization_is_activex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_is_activex ON data_denormalization USING btree (is_active);


--
-- Name: data_denormalization_organization_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_organization_idx ON data_denormalization USING btree (organization_id);


--
-- Name: data_denormalization_organization_namex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_organization_namex ON data_denormalization USING btree (organization_name);


--
-- Name: data_denormalization_project_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_project_idx ON data_denormalization USING btree (project_id);


--
-- Name: data_denormalization_project_name_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_project_name_idx ON data_denormalization USING btree (project_name);


--
-- Name: data_denormalization_regions_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_regions_idsx ON data_denormalization USING gist (regions_ids);


--
-- Name: data_denormalization_sector_idsx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_sector_idsx ON data_denormalization USING gist (sector_ids);


--
-- Name: data_denormalization_site_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX data_denormalization_site_idx ON data_denormalization USING btree (site_id);


--
-- Name: index_changes_history_records_on_user_id_and_what_type_and_when; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_changes_history_records_on_user_id_and_what_type_and_when ON changes_history_records USING btree (user_id, what_type, "when");


--
-- Name: index_clusters_projects_on_cluster_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_clusters_projects_on_cluster_id ON clusters_projects USING btree (cluster_id);


--
-- Name: index_clusters_projects_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_clusters_projects_on_project_id ON clusters_projects USING btree (project_id);


--
-- Name: index_countries_on_the_geom; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_countries_on_the_geom ON countries USING gist (the_geom);


--
-- Name: index_countries_projects_on_country_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_countries_projects_on_country_id ON countries_projects USING btree (country_id);


--
-- Name: index_countries_projects_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_countries_projects_on_project_id ON countries_projects USING btree (project_id);


--
-- Name: index_donations_on_donor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_donor_id ON donations USING btree (donor_id);


--
-- Name: index_donations_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_project_id ON donations USING btree (project_id);


--
-- Name: index_donors_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donors_on_name ON donors USING btree (name);


--
-- Name: index_media_resources_on_element_type_and_element_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_resources_on_element_type_and_element_id ON media_resources USING btree (element_type, element_id);


--
-- Name: index_organizations2_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations2_on_name ON organizations2 USING btree (name);


--
-- Name: index_organizations_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_on_name ON organizations USING btree (name);


--
-- Name: index_organizations_projects_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_projects_on_organization_id ON organizations_projects USING btree (organization_id);


--
-- Name: index_organizations_projects_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_projects_on_project_id ON organizations_projects USING btree (project_id);


--
-- Name: index_pages_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_parent_id ON pages USING btree (parent_id);


--
-- Name: index_pages_on_permalink; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_permalink ON pages USING btree (permalink);


--
-- Name: index_pages_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_site_id ON pages USING btree (site_id);


--
-- Name: index_partners_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_partners_on_site_id ON partners USING btree (site_id);


--
-- Name: index_projects_on_end_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_end_date ON projects USING btree (end_date);


--
-- Name: index_projects_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_name ON projects USING btree (name);


--
-- Name: index_projects_on_primary_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_primary_organization_id ON projects USING btree (primary_organization_id);


--
-- Name: index_projects_on_the_geom; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_the_geom ON projects USING gist (the_geom);


--
-- Name: index_projects_regions_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_regions_on_project_id ON projects_regions USING btree (project_id);


--
-- Name: index_projects_regions_on_region_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_regions_on_region_id ON projects_regions USING btree (region_id);


--
-- Name: index_projects_sectors_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_sectors_on_project_id ON projects_sectors USING btree (project_id);


--
-- Name: index_projects_sectors_on_sector_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_sectors_on_sector_id ON projects_sectors USING btree (sector_id);


--
-- Name: index_projects_sites_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_sites_on_project_id ON projects_sites USING btree (project_id);


--
-- Name: index_projects_sites_on_project_id_and_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_projects_sites_on_project_id_and_site_id ON projects_sites USING btree (project_id, site_id);


--
-- Name: index_projects_sites_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_sites_on_site_id ON projects_sites USING btree (site_id);


--
-- Name: index_projects_tags_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_tags_on_project_id ON projects_tags USING btree (project_id);


--
-- Name: index_projects_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_tags_on_tag_id ON projects_tags USING btree (tag_id);


--
-- Name: index_regions_on_country_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_country_id ON regions USING btree (country_id);


--
-- Name: index_regions_on_level; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_level ON regions USING btree (level);


--
-- Name: index_regions_on_parent_region_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_parent_region_id ON regions USING btree (parent_region_id);


--
-- Name: index_regions_on_the_geom; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_the_geom ON regions USING gist (the_geom);


--
-- Name: index_resources_on_element_type_and_element_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_resources_on_element_type_and_element_id ON resources USING btree (element_type, element_id);


--
-- Name: index_site_layers_on_layer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_site_layers_on_layer_id ON site_layers USING btree (layer_id);


--
-- Name: index_site_layers_on_layer_style_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_site_layers_on_layer_style_id ON site_layers USING btree (layer_style_id);


--
-- Name: index_site_layers_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_site_layers_on_site_id ON site_layers USING btree (site_id);


--
-- Name: index_sites_on_geographic_context_geometry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_on_geographic_context_geometry ON sites USING gist (geographic_context_geometry);


--
-- Name: index_sites_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_on_name ON sites USING btree (name);


--
-- Name: index_sites_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_on_status ON sites USING btree (status);


--
-- Name: index_sites_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_on_url ON sites USING btree (url);


--
-- Name: index_stats_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stats_on_site_id ON stats USING btree (site_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: region_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects_regions
    ADD CONSTRAINT region_id_fk FOREIGN KEY (region_id) REFERENCES regions(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20101028113834');

INSERT INTO schema_migrations (version) VALUES ('20101028115129');

INSERT INTO schema_migrations (version) VALUES ('20101028133100');

INSERT INTO schema_migrations (version) VALUES ('20101028133927');

INSERT INTO schema_migrations (version) VALUES ('20101028134621');

INSERT INTO schema_migrations (version) VALUES ('20101028135048');

INSERT INTO schema_migrations (version) VALUES ('20101108162315');

INSERT INTO schema_migrations (version) VALUES ('20101108163209');

INSERT INTO schema_migrations (version) VALUES ('20101110105456');

INSERT INTO schema_migrations (version) VALUES ('20101110105502');

INSERT INTO schema_migrations (version) VALUES ('20101110114108');

INSERT INTO schema_migrations (version) VALUES ('20101110114438');

INSERT INTO schema_migrations (version) VALUES ('20101110161733');

INSERT INTO schema_migrations (version) VALUES ('20101110162254');

INSERT INTO schema_migrations (version) VALUES ('20101110162317');

INSERT INTO schema_migrations (version) VALUES ('20101110162603');

INSERT INTO schema_migrations (version) VALUES ('20101110163656');

INSERT INTO schema_migrations (version) VALUES ('20101116091100');

INSERT INTO schema_migrations (version) VALUES ('20101117100450');

INSERT INTO schema_migrations (version) VALUES ('20101117141706');

INSERT INTO schema_migrations (version) VALUES ('20101119102703');

INSERT INTO schema_migrations (version) VALUES ('20101122081057');

INSERT INTO schema_migrations (version) VALUES ('20101124120201');

INSERT INTO schema_migrations (version) VALUES ('20101124144950');

INSERT INTO schema_migrations (version) VALUES ('20101124155515');

INSERT INTO schema_migrations (version) VALUES ('20101124165848');

INSERT INTO schema_migrations (version) VALUES ('20101125162127');

INSERT INTO schema_migrations (version) VALUES ('20101125182340');

INSERT INTO schema_migrations (version) VALUES ('20101128172940');

INSERT INTO schema_migrations (version) VALUES ('20101128174136');

INSERT INTO schema_migrations (version) VALUES ('20101129152739');

INSERT INTO schema_migrations (version) VALUES ('20101130152816');

INSERT INTO schema_migrations (version) VALUES ('20101130164947');

INSERT INTO schema_migrations (version) VALUES ('20101201172805');

INSERT INTO schema_migrations (version) VALUES ('20101201174750');

INSERT INTO schema_migrations (version) VALUES ('20101202154700');

INSERT INTO schema_migrations (version) VALUES ('20101202171837');

INSERT INTO schema_migrations (version) VALUES ('20101202175526');

INSERT INTO schema_migrations (version) VALUES ('20101211105820');

INSERT INTO schema_migrations (version) VALUES ('20101211204623');

INSERT INTO schema_migrations (version) VALUES ('20101213130738');

INSERT INTO schema_migrations (version) VALUES ('20101214175852');

INSERT INTO schema_migrations (version) VALUES ('20101214185843');

INSERT INTO schema_migrations (version) VALUES ('20101216152205');

INSERT INTO schema_migrations (version) VALUES ('20101221102641');

INSERT INTO schema_migrations (version) VALUES ('20101221122740');

INSERT INTO schema_migrations (version) VALUES ('20101221125338');

INSERT INTO schema_migrations (version) VALUES ('20101221151517');

INSERT INTO schema_migrations (version) VALUES ('20101222065522');

INSERT INTO schema_migrations (version) VALUES ('20101222153232');

INSERT INTO schema_migrations (version) VALUES ('20101222162225');

INSERT INTO schema_migrations (version) VALUES ('20101223110143');

INSERT INTO schema_migrations (version) VALUES ('20101224091820');

INSERT INTO schema_migrations (version) VALUES ('20101227103614');

INSERT INTO schema_migrations (version) VALUES ('20110103105358');

INSERT INTO schema_migrations (version) VALUES ('20110104102847');

INSERT INTO schema_migrations (version) VALUES ('20110104104051');

INSERT INTO schema_migrations (version) VALUES ('20110104121538');

INSERT INTO schema_migrations (version) VALUES ('20110104190135');

INSERT INTO schema_migrations (version) VALUES ('20110107103059');

INSERT INTO schema_migrations (version) VALUES ('20110107190334');

INSERT INTO schema_migrations (version) VALUES ('20110110131044');

INSERT INTO schema_migrations (version) VALUES ('20110110191540');

INSERT INTO schema_migrations (version) VALUES ('20110110195011');

INSERT INTO schema_migrations (version) VALUES ('20110111113043');

INSERT INTO schema_migrations (version) VALUES ('20110208092114');

INSERT INTO schema_migrations (version) VALUES ('20110208105308');

INSERT INTO schema_migrations (version) VALUES ('20110602170808');

INSERT INTO schema_migrations (version) VALUES ('20111121131054');

INSERT INTO schema_migrations (version) VALUES ('20111201095952');

INSERT INTO schema_migrations (version) VALUES ('20111201114152');

INSERT INTO schema_migrations (version) VALUES ('20111201115943');

INSERT INTO schema_migrations (version) VALUES ('20111201145358');

INSERT INTO schema_migrations (version) VALUES ('20111226134501');

INSERT INTO schema_migrations (version) VALUES ('20120209122630');

INSERT INTO schema_migrations (version) VALUES ('20120210092657');

INSERT INTO schema_migrations (version) VALUES ('20120213165338');

INSERT INTO schema_migrations (version) VALUES ('20120214152607');

INSERT INTO schema_migrations (version) VALUES ('20120417111053');

INSERT INTO schema_migrations (version) VALUES ('20120504115709');

INSERT INTO schema_migrations (version) VALUES ('20130128100737');

INSERT INTO schema_migrations (version) VALUES ('20130128140613');

INSERT INTO schema_migrations (version) VALUES ('20130204150246');

INSERT INTO schema_migrations (version) VALUES ('20130211142500');

INSERT INTO schema_migrations (version) VALUES ('20130212123245');

INSERT INTO schema_migrations (version) VALUES ('20130218104721');

INSERT INTO schema_migrations (version) VALUES ('20130304121255');

INSERT INTO schema_migrations (version) VALUES ('20130226145909');

INSERT INTO schema_migrations (version) VALUES ('20130325152416');

INSERT INTO schema_migrations (version) VALUES ('20130325161448');

INSERT INTO schema_migrations (version) VALUES ('20130321180629');

INSERT INTO schema_migrations (version) VALUES ('20130325172919');

INSERT INTO schema_migrations (version) VALUES ('20130419200211');

INSERT INTO schema_migrations (version) VALUES ('20130419201156');

INSERT INTO schema_migrations (version) VALUES ('20130419202532');

INSERT INTO schema_migrations (version) VALUES ('20131126085647');

INSERT INTO schema_migrations (version) VALUES ('20131126085813');

INSERT INTO schema_migrations (version) VALUES ('20131126093052');

INSERT INTO schema_migrations (version) VALUES ('20131212114120');

INSERT INTO schema_migrations (version) VALUES ('20131212114555');

INSERT INTO schema_migrations (version) VALUES ('20131212155239');

INSERT INTO schema_migrations (version) VALUES ('20131212163356');

INSERT INTO schema_migrations (version) VALUES ('20140109151033');

INSERT INTO schema_migrations (version) VALUES ('20140213155722');

INSERT INTO schema_migrations (version) VALUES ('20140217165847');

INSERT INTO schema_migrations (version) VALUES ('20140218173336');

INSERT INTO schema_migrations (version) VALUES ('20140219164037');

INSERT INTO schema_migrations (version) VALUES ('20140530130528');