DROP DATABASE IF EXISTS one_stop;
CREATE DATABASE one_stop;

\c one_stop

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(32),
  img VARCHAR(255),
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
  user_id INTEGER REFERENCES users(id)

);
CREATE TABLE likes(
  id SERIAL PRIMARY KEY,
  count INTEGER
);

CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  comment VARCHAR,
  user_id INTEGER REFERENCES users(id)
);

CREATE TABLE posts(
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  content VARCHAR,
  like_id INTEGER REFERENCES likes (id),
  comment_id INTEGER REFERENCES comments(id),
  user_id INTEGER REFERENCES users(id)
);



