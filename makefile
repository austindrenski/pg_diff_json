EXTENSION  = pg_diff_json
DATA       = pg_diff_json--0.0.1.sql
REGRESS    = pg_diff_json_test

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)