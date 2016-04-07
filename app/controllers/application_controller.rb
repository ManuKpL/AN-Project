class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :check_status, :is_current_page?

  private

  def check_status(element)
    if element.length == 1 && Deputy.where('lastname LIKE ?', "#{element}%").empty?
      ' disabled'
    else
      ''
    end
  end

  def is_current_page?(element)
    search = params[:search].nil? ? '' : params[:search]
    element == search.capitalize || element == search.upcase
  end

  def set_departments
    @departments = Hash.new
    Circonscription.all.each do |circonscription|
      @departments["#{circonscription.department_num} - #{circonscription.department}"] = circonscription.department_num
    end
  end

  def ordinalize_FR(number, genre)
    if genre == 'F'
      number == 1 ? "#{number}ère" : "#{number}ème"
    elsif genre == 'M'
      number == 1 ? "#{number}er" : "#{number}ème"
    end
  end
end
