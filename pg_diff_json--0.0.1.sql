-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION pg_diff_json" to load this file. \quit

-- types

CREATE TYPE CHANGE_TYPE AS ENUM ('+', '-');

CREATE TYPE CHANGESET AS (
  type  CHANGE_TYPE,
  path  TEXT [],
  value JSONB
);

-- function signatures

-- noinspection SqlUnused
CREATE OR REPLACE FUNCTION diff_jsonb(TEXT [], JSONB, JSONB) RETURNS CHANGESET [] AS
$$SELECT NULL :: CHANGESET []$$ LANGUAGE SQL IMMUTABLE;

-- _diff_primitives

CREATE OR REPLACE FUNCTION _diff_jsonb_primitives(path TEXT [], a JSONB, b JSONB) RETURNS CHANGESET [] AS
$_diff_jsonb_primitives$
SELECT CASE
       WHEN a = b THEN NULL
       WHEN b IS NOT NULL THEN ARRAY [('+', path, b) :: CHANGESET]
       WHEN a IS NOT NULL THEN ARRAY [('-', path, NULL) :: CHANGESET]
       END;
$_diff_jsonb_primitives$ LANGUAGE SQL IMMUTABLE;

-- _diff_objects

CREATE OR REPLACE FUNCTION _diff_jsonb_objects(path TEXT [], a JSONB, b JSONB) RETURNS CHANGESET [] AS
$_diff_jsonb_objects$
DECLARE
  changes CHANGESET [];
  a_keys  TEXT [];
  b_keys  TEXT [];
  key     TEXT;
BEGIN
  IF (a = b) THEN
    RETURN changes;
  END IF;

  a_keys := ARRAY(SELECT jsonb_object_keys(a));
  b_keys := ARRAY(SELECT jsonb_object_keys(b));

  FOR key IN SELECT unnest(a_keys) INTERSECT SELECT unnest(b_keys) LOOP
    changes := changes || _diff_jsonb(path || key, a -> key, b -> key);
  END LOOP;

  FOR key IN SELECT unnest(a_keys) EXCEPT SELECT unnest(b_keys) LOOP
    changes := changes || ('-', path || key, NULL) :: CHANGESET;
  END LOOP;

  FOR key IN SELECT unnest(b_keys) EXCEPT SELECT unnest(a_keys) LOOP
    changes := changes || ('+', path || key, b -> key) :: CHANGESET;
  END LOOP;

  RETURN changes;
END;
$_diff_jsonb_objects$ LANGUAGE plpgsql IMMUTABLE;

-- _diff_arrays

CREATE OR REPLACE FUNCTION _diff_jsonb_arrays(path TEXT [], a JSONB, b JSONB) RETURNS CHANGESET [] AS
$_diff_jsonb_arrays$
DECLARE
  changes CHANGESET [];
  key     INTEGER;
  a_keys  INTEGER [];
  b_keys  INTEGER [];
BEGIN
  IF (a = b) THEN
    RETURN changes;
  END IF;

  a_keys := ARRAY(SELECT generate_series(0, jsonb_array_length(a) - 1));
  b_keys := ARRAY(SELECT generate_series(0, jsonb_array_length(b) - 1));

  FOR key IN SELECT unnest(a_keys) INTERSECT SELECT unnest(b_keys) LOOP
    changes := changes || _diff_jsonb(path || key :: TEXT, a -> key, b -> key);
  END LOOP;

  FOR key IN SELECT unnest(a_keys) EXCEPT SELECT unnest(b_keys) LOOP
    changes := changes || ('-', path || key :: TEXT, NULL) :: CHANGESET;
  END LOOP;

  FOR key IN SELECT unnest(b_keys) EXCEPT SELECT unnest(a_keys) LOOP
    changes := changes || ('+', path || key :: TEXT, b -> key) :: CHANGESET;
  END LOOP;

  RETURN changes;
END;
$_diff_jsonb_arrays$ LANGUAGE plpgsql IMMUTABLE;

-- _diff

CREATE OR REPLACE FUNCTION _diff_jsonb(path TEXT [], a JSONB, b JSONB) RETURNS CHANGESET [] AS
$_diff_jsonb$
SELECT CASE
       WHEN a = b THEN NULL
       WHEN jsonb_typeof(a) = 'object' THEN _diff_jsonb_objects(path, a, b)
       WHEN jsonb_typeof(a) = 'array' THEN _diff_jsonb_arrays(path, a, b)
       ELSE _diff_jsonb_primitives(path, a, b)
       END;
$_diff_jsonb$ LANGUAGE SQL IMMUTABLE;

-- diff_json

CREATE OR REPLACE FUNCTION diff_json(JSON, JSON) RETURNS CHANGESET [] AS
$diff_json$
SELECT _diff_jsonb(NULL, $1 :: JSONB, $2 :: JSONB);
$diff_json$ LANGUAGE SQL IMMUTABLE STRICT;

-- diff_jsonb

CREATE OR REPLACE FUNCTION diff_jsonb(JSONB, JSONB) RETURNS CHANGESET [] AS
$diff_jsonb$
SELECT _diff_jsonb(NULL, $1, $2);
$diff_jsonb$ LANGUAGE SQL IMMUTABLE STRICT;