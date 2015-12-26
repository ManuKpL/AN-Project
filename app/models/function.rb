class Function < ActiveRecord::Base
  belongs_to :deputy
  belongs_to :organe

  validates_presence_of :deputy_id, :organe_id, :status, :organe_type
end
