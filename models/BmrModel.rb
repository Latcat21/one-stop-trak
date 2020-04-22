class Bmr < ActiveRecord::Base
  belongs_to :user
  self.table_name = 'bmr'
end