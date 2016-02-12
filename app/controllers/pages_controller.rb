class PagesController < ApplicationController
  before_action :set_groups, only: :home
  helper_method :check_status

  def home
    @deputy = Deputy.order(:lastname).first

  end

  private

  def check_status(element)
    " disabled" if element.length == 1 && Deputy.where('lastname LIKE ?', "#{element}%").empty?
  end

  def set_groups
    @groups = Group.order(:sigle)
  end
end
