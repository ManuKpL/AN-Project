class PagesController < ApplicationController
  before_action :set_groups, only: :home

  def home
    @deputy = Deputy.order(:lastname).first

  end

  private

  def set_groups
    @groups = Group.order(:sigle)
  end
end
