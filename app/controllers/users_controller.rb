class UsersController < ApplicationController
  def index
    response = ApiClient.users(session[:token])
    @users = response.body["users"]
  end

  def new
    load_form_options
  end

  def create
    response = ApiClient.create_user(session[:token], user_params.to_h)
    if response.success?
      redirect_to user_path(response.body["user"]["id"]), notice: "User created successfully."
    else
      load_form_options
      flash.now[:alert] = response.body["error"] || "Could not create user."
      render :new, status: :unprocessable_entity
    end
  end

def show
  response = ApiClient.user(session[:token], params[:id])
  @user = response.body["user"]
  @assignments = response.body["branch_assignments"]
  @assigned_branch_ids = @assignments.map { |a| a["branch_id"] }
  @branches = ApiClient.branches(session[:token]).body["branches"]

  balances_response = ApiClient.leave_balances(session[:token], @user["id"])
  Rails.logger.info "LEAVE BALANCES DEBUG: status=#{balances_response.status} body=#{balances_response.body.inspect}"
  @leave_balances = balances_response.body["leave_balances"]

  @leave_types = ApiClient.admin_leave_types(session[:token]).body["leave_types"]
end

  def toggle_branch
    result = ApiClient.toggle_branch(session[:token], params[:id], params[:branch_id])
    flash[:alert] = result.body["error"] if result.status == 422
    redirect_to user_path(params[:id])
  end

  def edit
    response = ApiClient.user(session[:token], params[:id])
    @user = response.body["user"]
    load_form_options
  end

  def update
    response = ApiClient.update_user(session[:token], params[:id], edit_params.to_h)
    if response.success?
      redirect_to user_path(params[:id]), notice: "User updated successfully."
    else
      response = ApiClient.user(session[:token], params[:id])
      @user = response.body["user"]
      load_form_options
      flash.now[:alert] = response.body["error"] || "Could not update user."
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def load_form_options
    @branches = ApiClient.branches(session[:token]).body["branches"]
    @positions = ApiClient.positions(session[:token]).body["positions"]
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :first_name, :last_name, :middle_name,
      :username, :role, :status, :position_id, :branch_id
    )
  end

  def edit_params
    params.require(:user).permit(:email, :first_name, :last_name, :middle_name, :username, :role, :status, :position_id)
  end
end
