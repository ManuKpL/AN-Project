class DeputiesController < ApplicationController

  before_action only: :index do
    set_departments #voir ApplicationController
    set_groups #voir ApplicationController
    analyse_search # prioritaire: détermine :set_deputy
  end

  before_action :set_deputy, :set_ages

  before_action only: :show do
    set_address
    set_mandate_and_circonscription
    set_previous_and_next
  end

  helper_method :set_next, :set_previous, :find_website, :find_emails, :find_age, :is_current_page?

  def show
  end

  def index
  end

  private

# strong param

  def search_params
    params.require(:search).permit(:grp, :dep, :ini, :age, :pro)
  end

# used only by index

  def analyse_search
    select_by_age(search_params[:age])        if search_params[:age].present?
    select_by_group(search_params[:grp])      if search_params[:grp].present?
    select_by_initial(search_params[:ini])    if search_params[:ini].present?
    select_by_department(search_params[:dep]) if search_params[:dep].present?
    select_by_profession(search_params[:pro]) if search_params[:pro].present?
    # redirect_to root_path
  end

  def select_by_age(search)
    if search.match(/\d{2,3}/)
      search = search.to_i
      if search >= 18 && search < 30
        @deputies = find_by_age(18, 30)
      elsif search >= 30 && search < 40
        @deputies = find_by_age(30, 40)
      elsif search >= 40 && search < 50
        @deputies = find_by_age(40, 50)
      elsif search >= 50 && search < 60
        @deputies = find_by_age(50, 60)
      elsif search >= 60 && search < 70
        @deputies = find_by_age(60, 70)
      elsif search >= 70 && search < 120
        @deputies = find_by_age(70, 120)
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def find_by_age(min, max)
    Deputy.all.select { |d| d if find_age(d) >= min && find_age(d) < max }
  end

  def select_by_group(search)
    search = "Écologiste" if %w(ecologiste écologiste ECOLOGISTE ecologistes écologistes ECOLOGISTES).include?(search)
    if Group.all.map(&:sigle).include?(search) || Group.all.map(&:sigle).include?(search.upcase!)
      @deputies = Deputy.where(group_id: Group.find_by(sigle: search).id).order(:lastname)
    else
      redirect_to root_path
    end
  end

  def select_by_initial(search)
    if search.to_s.match(/[a-zA-Z]/)
      @deputies = Deputy.where('lastname LIKE ?', "#{search.capitalize}%").order(:lastname)
    else
      redirect_to root_path
    end
  end

  def select_by_department(search)
    if @departments.values.include?(search) || (search.length == 1 && search.to_i >= 1)
      search = "0#{search}" if search.length == 1 && search.to_i >= 1
      @deputies = Deputy.all.select { |d| d if d.circonscriptions.last.department_num == search }
    else
      redirect_to root_path
    end
  end

  def select_by_profession(search)
    if Job.all.map(&:category).include?(search)
      @deputies = Deputy.all.select { |d| d if d.job.category == search }
    else
      redirect_to root_path
    end
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

  def is_current_page?(element, symbol)
    search = search_params[symbol].nil? ? '' : search_params[symbol]
    if search_params[:age].present?
      element == search[0].to_i * 10
    else
      element == search.capitalize || element == search.upcase
    end
  end
end
