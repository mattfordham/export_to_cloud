class Person < ActiveRecord::Base
  attr_accessible :age, :first_name, :is_admin, :last_name
end
