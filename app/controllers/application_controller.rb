class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def set_is_us(params, session)
    (params.has_key?(:is_us) && params[:is_us] == 'true') ||
      (session.has_key?(:is_us) && session[:is_us] == 'true') ? true : false
  end
end
