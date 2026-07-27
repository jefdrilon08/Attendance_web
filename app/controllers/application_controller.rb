class ApplicationController < ActionController::Base
  before_action :require_login

  helper_method :current_user, :logged_in?

  private

  def require_login
    redirect_to login_path, alert: "Please log in first." unless logged_in?
  end

  def logged_in?
    session[:token].present?
  end

  def current_user
    session[:user]
  end
end
