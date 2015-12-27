class DeputiesController < ApplicationController
  before_action :set_deputy, only: :show
  before_action :set_group, only: :index

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

  def index
    redirect_to root_path if @deputies.empty?
  end

  private

  def set_deputy
    @deputy = Deputy.find(params[:id].to_i)
  end

  def set_group
    @deputies = Deputy.where('lastname LIKE ?', "#{params[:search]}%").order(:lastname)
  end
end
