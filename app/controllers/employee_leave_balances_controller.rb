class EmployeeLeaveBalancesController < ApplicationController
  def create
    response = ApiClient.create_leave_balance(session[:token], params[:user_id], balance_params.to_h)
    if response.success?
      redirect_to user_path(params[:user_id]), notice: "Leave balance added."
    else
      redirect_to user_path(params[:user_id]), alert: response.body["error"] || "Could not add leave balance."
    end
  end

def update
  response = ApiClient.update_leave_balance(session[:token], params[:id], balance_params.to_h)
  if response.success?
    redirect_to user_path(params[:user_id]), notice: "Leave balance updated."
  else
    redirect_to user_path(params[:user_id]), alert: response.body["error"] || "Could not update leave balance."
  end
end
  private

  def balance_params
    params.require(:employee_leave_balance).permit(:leave_type_id, :year, :total_days, :used_days)
  end
end
