class Deputy < ActiveRecord::Base
  belongs_to :job
  belongs_to :group
  has_many :addresses
  has_many :e_addresses
  has_many :mandates
  has_many :functions
  has_many :phones, through: :addresses
  has_many :circonscriptions, through: :mandates
  has_many :organes, through: :functions

  # TO DO validates presence of group_id
  validates_presence_of :job_id, :civ, :firstname, :lastname, :original_tag
  validates_uniqueness_of :original_tag

  def full_name
    firstname + ' ' + lastname
  end
end
