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
  wake_up_time TIMESTAMP,
  task VARCHAR(255),
  food VARCHAR(255),
  workout VARCHAR(255),
  user_id INTEGER REFERENCES users(id)

);

CREATE TABLE  averages(
  avg_calories NUMERIC NOT NULL DEFAULT 'Nan',
  avg_time NUMERIC NOT NULL DEFAULT 'Nan',
  user_id INTEGER REFERENCES users(id)
);