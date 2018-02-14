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

-- two-level tests

\echo 'two-level test (identity)'
SELECT jsonb_diff($${
  "a": 0,
  "b": {
    "c": 2,
    "d": true
  }
}$$, $${
  "a": 0,
  "b": {
    "c": 2,
    "d": true
  }
}$$);

\echo 'two-level test (delete)'
SELECT jsonb_diff($${
  "a": 0,
  "b": {
    "c": 2,
    "d": true
  }
}$$, $${
  "a": 0,
  "b": {
    "c": 2
  }
}$$);

\echo 'two-level test (full delete)'
SELECT jsonb_diff($${
  "a": 0,
  "b": {
    "c": 2,
    "d": true
  }
}$$, $${
  "a": 0
}$$);

\echo 'two-level test (new value)'
SELECT jsonb_diff($${
  "a": 0,
  "b": {
    "c": 2,
    "d": true
  }
}$$, $${
  "a": 0,
  "b": {
    "c": 2,
    "d": false
  }
}$$);

\echo 'two-level test (new type)'
SELECT jsonb_diff($${
  "a": 0,
  "b": {
    "c": 2,
    "d": true
  }
}$$, $${
  "a": 0,
  "b": {
    "c": 2,
    "d": 3
  }
}$$);

\echo 'two-level test (new value and new type)'
SELECT jsonb_diff($${
  "a": 0,
  "b": {
    "c": 2,
    "d": true
  }
}$$, $${
  "a": 0,
  "b": {
    "c": true,
    "d": 3
  }
}$$);

\echo 'two-level test (new value and new type, multilevel)'
SELECT jsonb_diff($${
  "a": 0,
  "b": {
    "c": 2,
    "d": true
  }
}$$, $${
  "a": 1,
  "b": {
    "c": 2,
    "d": true
  }
}$$);

-- two-level array tests

\echo 'two-level array test (identity)'
SELECT jsonb_diff($${
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
SELECT jsonb_diff($${
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
SELECT jsonb_diff($${
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
SELECT jsonb_diff($${
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
SELECT jsonb_diff($${
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
SELECT jsonb_diff($${
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