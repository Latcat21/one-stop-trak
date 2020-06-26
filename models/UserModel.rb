class User < ActiveRecord::Base
  has_secure_password
  has_one  :bmr
  has_many :days
  has_many :posts
  has_many :comments
  has_many :meals
end