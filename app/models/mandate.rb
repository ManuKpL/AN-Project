class Mandate < ActiveRecord::Base
  belongs_to :deputy
  belongs_to :circonscription

  validates_presence_of :deputy_id, :circonscription_id, :seat_num
end
