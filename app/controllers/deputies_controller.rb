class DeputiesController < ApplicationController
  before_action :set_deputy

  def show
    ids_list = []
    Deputy.order(:lastname).each do |e|
      ids_list << e.id
    end
    @previous_id = Deputy.find(ids_list[ids_list.find_index(params[:id].to_i) - 1])
    if ids_list[ids_list.find_index(params[:id].to_i) + 1]
      @next_id = Deputy.find(ids_list[ids_list.find_index(params[:id].to_i) + 1])
    else
      @next_id = Deputy.find(ids_list.first)
    end
  end

  private

  def set_deputy
    @deputy = Deputy.find(params[:id].to_i)
  end
end
