CREATE DATABASE one_stop

\c one_stop

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(32),
  password VARCHAR(32)
);

CREATE TABLE traks(
  id SERIAL PRIMARY KEY,
  day TIMESTAMP,
  wake_up_time TIMESTAMP,
  task VARCHAR(255),
  food VARCHAR(255),
  workout VARCHAR(255)
  user_id INTEGER REFERENCES users(id)

);

CREATE TABLE  averages(
  avg_calories NUMERIC NOT NULL DEFAULT 'Nan',
  avg_time NUMERIC NOT NULL DEFAULT 'Nan'
);