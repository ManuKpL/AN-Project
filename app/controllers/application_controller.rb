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
    element == params[:search].to_s.capitalize || element == params[:search].to_s.upcase
  end
end
