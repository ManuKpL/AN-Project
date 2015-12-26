class Circonscription < ActiveRecord::Base
  has_many :mandates

  validates_presence_of :former_region, :department, :department_num, :circo_num
end
