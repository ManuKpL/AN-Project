class Organe < ActiveRecord::Base
  has_many :groups
  has_many :functions

  validates_presence_of :label, :original_tag
  validates_inclusion_of :current, :in => [true, false]
  validates_uniqueness_of :original_tag
end
