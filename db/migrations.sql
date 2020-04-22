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
  activity_level VARCHAR(255),
  img VARCHAR,
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

CREATE TABLE posts(
  id SERIAL PRIMARY KEY,
  category VARCHAR,
  title VARCHAR(255),
  author VARCHAR(255),
  content VARCHAR,
  img VARCHAR,
  user_id INTEGER REFERENCES users(id)
);

CREATE TABLE likes(
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  post_id INTEGER REFERENCES posts(id)
);

CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  comment VARCHAR,
  author VARCHAR(255),
  post_id INTEGER REFERENCES posts(id),
  user_id INTEGER REFERENCES users(id)
);

CREATE TABLE meals(
  id SERIAL PRIMARY KEY,
  name VARCHAR,
  img VARCHAR,
  instructions VARCHAR,
  ingredients VARCHAR,
  video VARCHAR,
  user_id INTEGER REFERENCES users(id),
  meal_id VARCHAR

);



