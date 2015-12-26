class Job < ActiveRecord::Base
  has_many :deputies

  validates_presence_of :label, :category, :family

  def name
    label
  end
end
