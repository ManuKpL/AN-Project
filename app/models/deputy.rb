class Deputy < ActiveRecord::Base
  belongs_to :job
  has_many :addresses
  has_many :e_addresses
  has_many :phones, through: :addresses

  validates :job_id, presence: true
end
