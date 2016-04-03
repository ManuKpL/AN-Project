class PagesController < ApplicationController
  before_action only: :home do
    set_groups
    set_departments
  end

  def home
    @deputy = Deputy.order(:lastname).first

  end

  private

  def set_groups
    @groups = Group.order(:sigle)
  end
end
