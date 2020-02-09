-- environment
CREATE EXTENSION pgcrypto;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email text NOT NULL,
  password text NOT NULL
);

-- hash password in database
CREATE OR REPLACE FUNCTION hash_password_func() RETURNS trigger AS $$
BEGIN
    NEW.password = crypt(NEW.password, gen_salt('bf', 10));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_or_insert_pswd_tg BEFORE INSERT OR UPDATE OF password ON users
FOR EACH ROW 
EXECUTE FUNCTION hash_password_func();

-- check password in database
CREATE OR REPLACE FUNCTION check_password(integer,text) RETURNS BOOLEAN AS $$
    DECLARE checkPswd BOOLEAN;
    BEGIN
        SELECT (password = crypt($2,password)) INTO checkPswd 
        FROM users WHERE id = $1;

        RETURN checkPswd;
    END;
$$ LANGUAGE plpgsql;

-- test
INSERT INTO users (email,password) VALUES ('test@test.fr','myPassword');
SELECT valid_password(1,'myPassword');

