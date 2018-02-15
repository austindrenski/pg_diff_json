-- two-level tests

\echo 'two-level test (identity)'
SELECT diff_jsonb($${
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
SELECT diff_jsonb($${
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
SELECT diff_jsonb($${
  "a": 0,
  "b": {
    "c": 2,
    "d": true
  }
}$$, $${
  "a": 0
}$$);

\echo 'two-level test (new value)'
SELECT diff_jsonb($${
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
SELECT diff_jsonb($${
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
SELECT diff_jsonb($${
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
SELECT diff_jsonb($${
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