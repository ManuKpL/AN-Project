class Phone < ActiveRecord::Base
  belongs_to :address

  validates :address_id, presence: true
end
