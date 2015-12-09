class Job < ActiveRecord::Base
  has_many :deputies

  def name
    label
  end
end
