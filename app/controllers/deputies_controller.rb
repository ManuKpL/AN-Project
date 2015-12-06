class DeputiesController < ApplicationController
  def show
    ids_list = []
    Deputy.order(:lastname).each do |e|
      ids_list << e.id
    end
    @previous_id = ids_list[ids_list.find_index(params[:id].to_i) - 1]
    @next_id = ids_list[ids_list.find_index(params[:id].to_i) + 1]
  end
end
