CREATE EXTENSION pg_diff_json;

-- one-level tests

\echo 'one-level test (identity)'
SELECT diff_jsonb($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 0,
  "b": 1
}$$);

\echo 'one-level test (delete)'
SELECT diff_jsonb($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 0
}$$);

\echo 'one-level test (new value)'
SELECT diff_jsonb($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 0,
  "b": 2
}$$);

\echo 'one-level test (new type)'
SELECT diff_jsonb($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 0,
  "b": true
}$$);

\echo 'one-level test (new value and new type)'
SELECT diff_jsonb($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 1,
  "b": true
}$$);