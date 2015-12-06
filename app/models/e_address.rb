class EAddress < ActiveRecord::Base
  belongs_to :deputy

  validates :deputy_id, presence: true
end
