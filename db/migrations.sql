DROP DATABASE IF EXISTS one_stop;
CREATE DATABASE one_stop;

\c one_stop

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(32),
  password_digest VARCHAR(60)
);
CREATE TABLE tasks(
  id SERIAL PRIMARY KEY,
  task VARCHAR(255)
);
CREATE TABLE foods(
  id SERIAL PRIMARY KEY,
  food VARCHAR(255)
);
CREATE TABLE workouts(
  id SERIAL PRIMARY KEY,
  workout VARCHAR(255)
);
CREATE TABLE calories(
  id SERIAL PRIMARY KEY,
  calorie  NUMERIC NOT NULL DEFAULT 'NaN'
);
CREATE TABLE days(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  time_awake TIME,
  task_id INTEGER REFERENCES tasks(id),
  food_id INTEGER REFERENCES foods(id),
  workout_id INTEGER REFERENCES workouts(id),
  calorie_id INTEGER REFERENCES calories(id),
  user_id INTEGER REFERENCES users(id)

);

