class Deputy < ActiveRecord::Base
  belongs_to :job
  has_many :addresses
  has_many :e_addresses
end
