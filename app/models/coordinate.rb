class Coordinate < ActiveRecord::Base
  belongs_to :deputy
  belongs_to :address
end
