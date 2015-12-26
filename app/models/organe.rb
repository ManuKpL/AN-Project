class Organe < ActiveRecord::Base
  has_many :groupes
  has_many :functions

  validates_presence_of :label, :current
end
