class EAddress < ActiveRecord::Base
  belongs_to :deputy

  validates_presence_of :deputy_id, :label, :value
end
