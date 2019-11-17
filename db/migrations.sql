DROP DATABASE IF EXISTS one_stop;
CREATE DATABASE one_stop;

\c one_stop

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(32),
  gender VARCHAR(32),
  age INTEGER,
  height INTEGER,
  weight INTEGER,
  bmr INTEGER,
  password_digest VARCHAR(60)
);

CREATE TABLE days(
  id SERIAL PRIMARY KEY,
  name DATE,
  time_awake TIME WITH TIME ZONE,
  task VARCHAR,
  food VARCHAR,
  workout VARCHAR,
  calorie BIGINT,
  img VARCHAR(255),
  user_id INTEGER REFERENCES users(id)

);

CREATE TABLE posts(
  id SERIAL PRIMARY KEY,
  post VARCHAR,
  name VARCHAR(32),
  img VARCHAR(255),
  like VARCHAR(255),
  user_id INTEGER REFERENCES users(id)
);

CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  comment VARCHAR,
  img VARCHAR(255),
  user_id INTEGER REFERENCES users(id)
);

