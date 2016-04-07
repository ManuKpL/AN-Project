class DeputiesController < ApplicationController

  before_action only: :index do
    set_groups #voir ApplicationController
  end

  before_action :set_departments, :analyse_search , :set_deputy, :set_ages
   #voir ApplicationController pour set_ages et set_departments

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

  def analyse_search
    if params[:search].nil? && params['action'] == 'index'
      redirect_to root_path
    elsif params[:search].nil? && params['action'] == 'show'
      nil
    elsif params[:search][:age].present?
      @deputies = select_by_age(params[:search][:age])
    elsif params[:search][:grp].present?
      @deputies = select_by_group(params[:search][:grp])
    elsif params[:search][:ini].present?
      @deputies = select_by_initial(params[:search][:ini])
    elsif params[:search][:dep].present?
      @deputies = select_by_department(params[:search][:dep])
    elsif params[:search][:pro].present?
      @deputies = select_by_profession(params[:search][:pro])
    elsif params['action'] == 'index'
      redirect_to root_path
    end
  end

  def select_by_age(search)
    if search.match(/\d{2,3}/)
      search = search.to_i
      if search >= 18 && search < 25
        find_by_age(18, 25)
      elsif search >= 25 && search < 30
        find_by_age(25, 30)
      elsif search >= 30 && search < 35
        find_by_age(30, 35)
      elsif search >= 35 && search < 40
        find_by_age(35, 40)
      elsif search >= 40 && search < 45
        find_by_age(40, 45)
      elsif search >= 45 && search < 50
        find_by_age(45, 50)
      elsif search >= 50 && search < 55
        find_by_age(50, 55)
      elsif search >= 55 && search < 60
        find_by_age(55, 60)
      elsif search >= 60 && search < 65
        find_by_age(60, 65)
      elsif search >= 65 && search < 70
        find_by_age(65, 70)
      elsif search >= 70 && search < 75
        find_by_age(70, 75)
      elsif search >= 75 && search < 120
        find_by_age(75, 120)
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def find_by_age(min, max)
    Deputy.order(:lastname).select { |d| d if find_age(d) >= min && find_age(d) < max }
  end

  def select_by_group(search)
    search = "Écologiste" if %w(ecologiste écologiste ECOLOGISTE ecologistes écologistes ECOLOGISTES).include?(search)
    if Group.all.map(&:sigle).include?(search) || Group.all.map(&:sigle).include?(search.upcase!)
      Deputy.where(group_id: Group.find_by(sigle: search).id).order(:lastname)
    else
      redirect_to root_path
    end
  end

  def select_by_initial(search)
    if search.to_s.match(/[a-zA-Z]/)
      Deputy.where('lastname LIKE ?', "#{search.capitalize}%").order(:lastname)
    else
      redirect_to root_path
    end
  end

  def select_by_department(search)
    if @departments.values.include?(search) || (search.length == 1 && search.to_i >= 1)
      search = "0#{search}" if search.length == 1 && search.to_i >= 1
      Deputy.order(:lastname).select { |d| d if d.circonscriptions.last.department_num == search }
    else
      redirect_to root_path
    end
  end

  def select_by_profession(search)
    if Job.all.map(&:category).include?(search)
      Deputy.order(:lastname).select { |d| d if d.job.category == search }
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
    @deputies = Deputy.order(:lastname) if @deputies.nil?
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
    search = params[:search][symbol].nil? ? '' : params[:search][symbol]
    if params[:search][:age].present?
      element == search[0].to_i * 10
    else
      element == search.capitalize || element == search.upcase
    end
  end

  def has_nobody?(age)
    select_by_age(age.to_s).empty?
  end
end
