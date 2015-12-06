class PagesController < ApplicationController
  def home
    @deputy = Deputy.first
  end
end
