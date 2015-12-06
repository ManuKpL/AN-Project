class PagesController < ApplicationController
  def home
    @deputy = Deputy.order(:lastname).first
  end
end
