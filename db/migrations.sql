DROP DATABASE IF EXISTS one_stop;
CREATE DATABASE one_stop;

\c one_stop

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(32),
  password_digest VARCHAR(60)
);

CREATE TABLE days(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  time_awake VARCHAR(255),
  task VARCHAR(255),
  food VARCHAR(255),
  workout VARCHAR(255),
  calorie NUMERIC NOT NULL DEFAULT 'NaN',
  user_id INTEGER REFERENCES users(id)

);

