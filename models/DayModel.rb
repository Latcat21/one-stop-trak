class Day < ActiveRecord::Base
  belongs_to :user
  has_many :calories
  has_many :foods
  has_many :workouts
  has_many :tasks
end