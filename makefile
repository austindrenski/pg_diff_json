EXTENSION  = pg_diff_json
DATA       = pg_diff_json--0.0.1.sql
REGRESS    = one_level_tests \
             two_level_tests \
             two_level_array_tests

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)