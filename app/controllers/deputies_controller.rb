class DeputiesController < ApplicationController
  before_action :set_group, only: :index
  before_action only: :show do
    set_deputy
    set_previous_and_next
  end
  helper_method :check_status, :set_next, :set_previous

  def show
    @mandate = @deputy.mandates.last
    @circo = @mandate.circonscription
  end

  def index
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
    @deputies = Deputy.order(:lastname)
    @previous_id = set_previous(@deputy)
    @next_id = set_next(@deputy)
  end

  def set_group
    search = params[:search]
    if search.nil?
      redirect_to root_path
    else
      if search.length == 1 && search.to_i == 0 && search != "0"
        @deputies = Deputy.where('lastname LIKE ?', "#{search.capitalize}%").order(:lastname)
      elsif Group.all.map(&:sigle).include?(search)
        @deputies = Deputy.where(group_id: Group.find_by(sigle: params[:search]).id).order(:lastname)
      elsif Circonscription.all.map(&:department_num).include?(search) || (search.length == 1 && search.to_i >= 1)
        search = "0#{search}" if search.length == 1 && search.to_i >= 1
        @deputies = []
        Circonscription.where(department_num: search).each do |circo|
          @deputies << Deputy.find(Mandate.where(circonscription_id: circo.id).last.deputy_id)
        end
      else
        redirect_to root_path
      end
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
