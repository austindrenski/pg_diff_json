-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION pg_diff_json" to load this file. \quit

-- function signatures

-- noinspection SqlUnused
CREATE OR REPLACE FUNCTION json_diff(JSON, JSON) RETURNS JSON AS
$$SELECT NULL :: JSON$$ LANGUAGE SQL IMMUTABLE STRICT;
-- noinspection SqlUnused
CREATE OR REPLACE FUNCTION jsonb_diff(JSONB, JSONB) RETURNS JSONB AS
$$SELECT NULL :: JSONB$$ LANGUAGE SQL IMMUTABLE STRICT;
-- noinspection SqlUnused
CREATE OR REPLACE FUNCTION _jsonb_diff(JSONB, JSONB, JSONB) RETURNS JSONB AS
$$SELECT NULL :: JSONB$$ LANGUAGE SQL IMMUTABLE;
-- noinspection SqlUnused
CREATE OR REPLACE FUNCTION _jsonb_diff_primitives(JSONB, JSONB, JSONB) RETURNS JSONB AS
$$SELECT NULL :: JSONB$$ LANGUAGE SQL IMMUTABLE;
-- noinspection SqlUnused
CREATE OR REPLACE FUNCTION _jsonb_diff_objects(JSONB, JSONB, JSONB) RETURNS JSONB AS
$$SELECT NULL :: JSONB$$ LANGUAGE SQL IMMUTABLE;
-- noinspection SqlUnused
CREATE OR REPLACE FUNCTION _jsonb_diff_arrays(JSONB, JSONB, JSONB) RETURNS JSONB AS
$$SELECT NULL :: JSONB$$ LANGUAGE SQL IMMUTABLE;

-- json_diff

CREATE OR REPLACE FUNCTION json_diff(JSON, JSON) RETURNS JSON AS
$json_diff$
SELECT _jsonb_diff('[]' :: JSONB, $1 :: JSONB, $2 :: JSONB) :: JSON;
$json_diff$ LANGUAGE SQL IMMUTABLE STRICT;

-- jsonb_diff

CREATE OR REPLACE FUNCTION jsonb_diff(JSONB, JSONB) RETURNS JSONB AS
$jsonb_diff$
SELECT _jsonb_diff('[]' :: JSONB, $1, $2);
$jsonb_diff$ LANGUAGE SQL IMMUTABLE STRICT;

-- _jsonb_diff

CREATE OR REPLACE FUNCTION _jsonb_diff(path JSONB, a JSONB, b JSONB) RETURNS JSONB AS
$_jsonb_diff$
SELECT CASE
       WHEN a = b THEN '[]' :: JSONB
       WHEN jsonb_typeof(a) = 'object' THEN _jsonb_diff_objects(path, a, b)
       WHEN jsonb_typeof(a) = 'array' THEN _jsonb_diff_arrays(path, a, b)
       ELSE _jsonb_diff_primitives(path, a, b)
       END;
$_jsonb_diff$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION _jsonb_diff_primitives(path JSONB, a JSONB, b JSONB) RETURNS JSONB AS
$_jsonb_diff_primitives$
SELECT CASE
       WHEN a = b THEN '[]' :: JSONB
       WHEN b IS NOT NULL THEN jsonb_build_object('type', '+', 'key', path, 'value', b)
       WHEN a IS NOT NULL THEN jsonb_build_object('type', '-', 'key', path)
       END;
$_jsonb_diff_primitives$ LANGUAGE SQL IMMUTABLE;

-- _jsonb_diff_objects

CREATE OR REPLACE FUNCTION _jsonb_diff_objects(path JSONB, a JSONB, b JSONB) RETURNS JSONB AS
$_jsonb_diff_objects$
DECLARE
  changes JSONB = '[]';
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
    changes := changes || _jsonb_diff(path || to_jsonb(key), a -> key, b -> key);
  END LOOP;

  FOR key IN SELECT unnest(a_keys) EXCEPT SELECT unnest(b_keys) LOOP
    changes := changes || jsonb_build_object('type', '-', 'key', path || to_jsonb(key));
  END LOOP;

  FOR key IN SELECT unnest(b_keys) EXCEPT SELECT unnest(a_keys) LOOP
    changes := changes || jsonb_build_object('type', '+', 'key', path || to_jsonb(key), 'value', b -> key);
  END LOOP;

  RETURN changes;
END;
$_jsonb_diff_objects$ LANGUAGE plpgsql IMMUTABLE;

-- _jsonb_diff_arrays

CREATE OR REPLACE FUNCTION _jsonb_diff_arrays(path JSONB, a JSONB, b JSONB) RETURNS JSONB AS
$_jsonb_diff_arrays$
DECLARE
  changes JSONB = '[]';
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
    changes := changes || _jsonb_diff(path || to_jsonb(key), a -> key, b -> key);
  END LOOP;

  FOR key IN SELECT unnest(a_keys) EXCEPT SELECT unnest(b_keys) LOOP
    changes := changes || jsonb_build_object('type', '-', 'key', path || to_jsonb(key));
  END LOOP;

  FOR key IN SELECT unnest(b_keys) EXCEPT SELECT unnest(a_keys) LOOP
    changes := changes || jsonb_build_object('type', '+', 'key', path || to_jsonb(key), 'value', b -> key);
  END LOOP;

  RETURN changes;
END;
$_jsonb_diff_arrays$ LANGUAGE plpgsql IMMUTABLE;