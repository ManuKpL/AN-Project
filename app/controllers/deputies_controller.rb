class DeputiesController < ApplicationController
  before_action :set_group, :set_deputy
  before_action :set_previous_and_next, only: :show
  helper_method :check_status, :set_next, :set_previous

  def show
  end

  def index
    redirect_to root_path if @deputies.length == 577
  end

  private

  def set_deputy
    if params[:id]
      @deputy = Deputy.find(params[:id].to_i)
    else
      @deputy = @deputies.first
    end
  end

  def set_previous_and_next
    @previous_id = set_previous(@deputy)
    @next_id = set_next(@deputy)
  end

  def set_group
    if params[:search].nil? || Group.find_by(sigle: params[:search]).nil?
      @deputies = Deputy.order(:lastname)
    elsif params[:search].length == 1
      @deputies = Deputy.where('lastname LIKE ?', "#{params[:search].capitalize}%").order(:lastname)
    else
      @deputies = Deputy.where(group_id: Group.find_by(sigle: params[:search]).id).order(:lastname)
    end
    @groups = Group.order(:sigle)
  end

  def set_previous(deputy)
    ids_list = @deputies.map(&:id)
    return Deputy.find(ids_list[ids_list.find_index(deputy.id) - 1])
  end

  def set_next(deputy)
    ids_list = @deputies.map(&:id)
    if ids_list[ids_list.find_index(deputy.id) + 1]
      return Deputy.find(ids_list[ids_list.find_index(deputy.id) + 1])
    else
      return Deputy.find(ids_list.first)
    end
  end

  def check_status(element)
    if element.length == 1 && Deputy.where('lastname LIKE ?', "#{element}%").empty?
      " disabled"
    elsif element == params[:search].capitalize || element == params[:search].upcase
      " btn-success"
    end
  end
end
