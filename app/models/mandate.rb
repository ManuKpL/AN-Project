class Mandate < ActiveRecord::Base
  belongs_to :deputy
  belongs_to :circonscription
end
