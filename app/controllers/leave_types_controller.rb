class LeaveTypesController < ApplicationController
  before_action :require_admin_or_hr

  def index
    @leave_types = ApiClient.admin_leave_types(session[:token]).body["leave_types"]
  end

  def new
  end

  def create
    response = ApiClient.create_leave_type(session[:token], leave_type_params.to_h)
    if response.success?
      redirect_to leave_types_path, notice: "Leave type created successfully."
    else
      flash.now[:alert] = response.body["error"] || "Could not create leave type."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @leave_type = ApiClient.admin_leave_type(session[:token], params[:id]).body["leave_type"]
  end

  def update
    response = ApiClient.update_leave_type(session[:token], params[:id], leave_type_params.to_h)
    if response.success?
      redirect_to leave_types_path, notice: "Leave type updated successfully."
    else
      @leave_type = ApiClient.admin_leave_type(session[:token], params[:id]).body["leave_type"]
      flash.now[:alert] = response.body["error"] || "Could not update leave type."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_admin_or_hr
    unless current_user && %w[admin hr].include?(current_user["role"])
      redirect_to root_path, alert: "Not authorized."
    end
  end

  def leave_type_params
    params.require(:leave_type).permit(:name, :code, :max_days_per_year)
  end
end
