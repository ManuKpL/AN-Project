class DeputiesController < ApplicationController

  before_action only: :index do
    set_groups # prioritaire: détermine :set_deputy
    set_departments #voir ApplicationController
  end

  before_action :set_deputy

  before_action only: :show do
    set_address
    set_mandate_and_circonscription
    set_previous_and_next
  end

  helper_method :set_next, :set_previous, :find_website, :find_emails, :find_age

  def show
  end

  def index
  end

  private

# used only by index

  def set_groups
    search = params[:search]
    search = "Écologiste" if %w(ecologiste écologiste ECOLOGISTE).include?(params[:search])
    if search.nil?
      redirect_to root_path
    else
      if search.length == 1 && search.to_i == 0 && search != "0"
        @deputies = Deputy.where('lastname LIKE ?', "#{search.capitalize}%").order(:lastname)
      elsif Group.all.map(&:sigle).include?(search) || Group.all.map(&:sigle).include?(search.upcase!)
        @deputies = Deputy.where(group_id: Group.find_by(sigle: search).id).order(:lastname)
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

# used by both index and show

  def set_deputy
    if params[:id]
      @deputy = Deputy.find(params[:id].to_i)
    else
      @deputy = @deputies.first
    end
  end

# used by show

  def set_address
    @address = @deputy.addresses.last.label == 'NR' ? @deputy.addresses[-1] : @deputy.addresses.last
  end

  def set_mandate_and_circonscription
    @mandate = @deputy.mandates.last
    @circo = @mandate.circonscription
  end

  def set_previous_and_next
    @deputies = Deputy.order(:lastname)
    @previous_id = set_previous(@deputy)
    @next_id = set_next(@deputy)
  end

# helper methods

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

  def find_age(deputy)
    age = Date.today.year - deputy.birthday.year
    age = Date.today < deputy.birthday + age.years ? age - 1 : age
  end

  def find_website(deputy)
    websites = deputy.e_addresses.where(label: 'Site internet')
    websites.empty? ? '' : websites.first.value
  end

  def find_emails(deputy)
    deputy.e_addresses.where(label: 'Mèl').map(&:value)
  end

end
