-- two-level array tests

\echo 'two-level array test (identity)'
SELECT diff_jsonb($${
  "a": 0,
  "b": [
    0,
    1,
    2
  ]
}$$, $${
  "a": 0,
  "b": [
    0,
    1,
    2
  ]
}$$);

\echo 'two-level array test (delete)'
SELECT diff_jsonb($${
  "a": 0,
  "b": [
    0,
    1,
    2
  ]
}$$, $${
  "a": 0,
  "b": [
    0,
    1
  ]
}$$);

\echo 'two-level array test (full delete)'
SELECT diff_jsonb($${
  "a": 0,
  "b": [
    0,
    1,
    2
  ]
}$$, $${
  "a": 0
}$$);

\echo 'two-level array test (new value)'
SELECT diff_jsonb($${
  "a": 0,
  "b": [
    0,
    1,
    2
  ]
}$$, $${
  "a": 0,
  "b": [
    0,
    1,
    3
  ]
}$$);

\echo 'two-level array test (new type)'
SELECT diff_jsonb($${
  "a": 0,
  "b": [
    0,
    1,
    2
  ]
}$$, $${
  "a": 0,
  "b": [
    0,
    1,
    false
  ]
}$$);

\echo 'two-level test (new value and new type, multilevel)'
SELECT diff_jsonb($${
  "a": 0,
  "b": [
    0,
    1,
    2
  ]
}$$, $${
  "a": 1,
  "b": [
    0,
    1,
    false
  ]
}$$);