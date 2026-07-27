class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

def create
  response = ApiClient.login(params.dig(:user, :email), params.dig(:user, :password))

  if response.success?
    raw_token = response.headers["authorization"]
    token = raw_token&.start_with?("Bearer ") ? raw_token.sub("Bearer ", "") : raw_token

    if token.present?
      session[:token] = token
      me_response = ApiClient.me(token)
      session[:user] = me_response.success? ? me_response.body : nil
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Login succeeded but no token was returned."
      render :new, status: :unprocessable_entity
    end
  else
    flash.now[:alert] = "Invalid email or password."
    render :new, status: :unprocessable_entity
  end
rescue Faraday::ConnectionFailed
  flash.now[:alert] = "Could not reach the server. Please try again."
  render :new, status: :service_unavailable
end

  def destroy
    reset_session
    redirect_to login_path, notice: "Logged out."
  end
end
