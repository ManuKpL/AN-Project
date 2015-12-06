class Address < ActiveRecord::Base
  belongs_to :deputy
  has_many :phones
end
