-- environment
CREATE TABLE keys (
  key1 INT NOT NULL,
  key2 INT NOT NULL,
  CONSTRAINT unique_key_pair UNIQUE(key1,key2)
);

-- test
INSERT INTO keys (key1,key2) VALUES (1,2);
INSERT INTO keys (key1,key2) VALUES (1,2);
