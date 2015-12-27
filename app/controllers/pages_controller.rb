class PagesController < ApplicationController
  helper_method :check_status

  def home
    @deputy = Deputy.order(:lastname).first

  end

  private

  def check_status(letter)
    Deputy.where('lastname LIKE ?', "#{letter}%").empty? ? " disabled" : ""
  end
end
