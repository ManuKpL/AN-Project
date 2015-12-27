class Job < ActiveRecord::Base
  has_many :deputies

  validates_presence_of :label, :category, :family
  validates_uniqueness_of :label, :scope => [:category, :family]

  def name
    label
  end
end
