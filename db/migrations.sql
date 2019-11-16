DROP DATABASE IF EXISTS one_stop;
CREATE DATABASE one_stop;

\c one_stop

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(32),
  gender VARCHAR(32),
  age NUMERIC NOT NULL DEFAULT 'NaN',
  height NUMERIC NOT NULL DEFAULT 'NaN',
  weight NUMERIC NOT NULL DEFAULT 'NaN',
  bmr NUMERIC,
  password_digest VARCHAR(60)
);

CREATE TABLE days(
  id SERIAL PRIMARY KEY,
  name DATE,
  time_awake TIME WITH TIME ZONE,
  task VARCHAR(255),
  food VARCHAR(255),
  workout VARCHAR(255),
  calorie BIGINT,
  user_id INTEGER REFERENCES users(id)

);

