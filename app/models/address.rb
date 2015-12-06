class Address < ActiveRecord::Base
  belongs_to :deputy
  has_many :phones

  validates :deputy_id, presence: true
end
