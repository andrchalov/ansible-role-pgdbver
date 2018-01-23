
CREATE TABLE test.test (id int);

INSERT INTO test.test (id) SELECT generate_series(1, 100);
