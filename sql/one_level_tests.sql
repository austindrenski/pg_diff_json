-- one-level tests

\echo 'one-level test (identity)'
SELECT jsonb_diff($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 0,
  "b": 1
}$$);

\echo 'one-level test (delete)'
SELECT jsonb_diff($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 0
}$$);

\echo 'one-level test (new value)'
SELECT jsonb_diff($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 0,
  "b": 2
}$$);

\echo 'one-level test (new type)'
SELECT jsonb_diff($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 0,
  "b": true
}$$);

\echo 'one-level test (new value and new type)'
SELECT jsonb_diff($${
  "a": 0,
  "b": 1
}$$, $${
  "a": 1,
  "b": true
}$$);