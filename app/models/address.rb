class Address < ActiveRecord::Base
  belongs_to :deputy
  has_many :phones

  validates_presence_of :deputy_id, :label, :value
  validates_uniqueness_of :original_tag
end
