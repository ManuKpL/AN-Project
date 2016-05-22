class Group < ActiveRecord::Base
  belongs_to :organe
  has_many :deputies

  validates_presence_of :sigle, :organe_id

  def name
    sigle
  end
end
