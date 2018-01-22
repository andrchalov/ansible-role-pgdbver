
CREATE TABLE test (id int);

INSERT INTO test (id) SELECT generate_series(1, 100);
