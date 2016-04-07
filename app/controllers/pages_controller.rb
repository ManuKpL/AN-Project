class PagesController < ApplicationController
  before_action only: :home do
    set_groups #voir ApplicationController
    set_departments #voir ApplicationController
    set_ages #voir ApplicationController
    set_deputy
  end

  def home
  end

  private

  def set_deputy
    @deputy = Deputy.order(:lastname).first
  end
end
