class Phone < ActiveRecord::Base
  belongs_to :address

  validates_presence_of :address_id, :label, :value
end
