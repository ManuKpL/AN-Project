class DeputiesController < ApplicationController
  before_action :set_deputy, :set_previous_and_next
  before_action :set_group, only: :index
  helper_method :check_status

  def show
  end

  def index
    redirect_to root_path if @deputies.empty?
  end

  private

  def set_deputy
    if params[:id]
      @deputy = Deputy.find(params[:id].to_i)
    else
      @deputy = Deputy.first
    end
  end

  def set_previous_and_next
    ids_list = []
    Deputy.order(:lastname).each do |e|
      ids_list << e.id
    end
    @previous_id = Deputy.find(ids_list[ids_list.find_index(@deputy.id) - 1])
    if ids_list[ids_list.find_index(@deputy.id) + 1]
      @next_id = Deputy.find(ids_list[ids_list.find_index(@deputy.id) + 1])
    else
      @next_id = Deputy.find(ids_list.first)
    end
  end

  def set_group
    if params[:search].nil?
      @deputies = []
    elsif params[:search].length == 1
      @deputies = Deputy.where('lastname LIKE ?', "#{params[:search].capitalize}%").order(:lastname)
    elsif Group.find_by(sigle: params[:search]).nil?
      @deputies = []
    else
      @deputies = Deputy.where(group_id: Group.find_by(sigle: params[:search]).id).order(:lastname)
    end
    @groups = Group.order(:sigle)
  end

  def check_status(element)
    if element.length == 1 && Deputy.where('lastname LIKE ?', "#{element}%").empty?
      " disabled"
    elsif element == params[:search].capitalize || element == params[:search].upcase
      " btn-success"
    end
  end
end
