class DtrSubmissionsController < ApplicationController

  before_action :require_approver, only: [:pending, :pending_period, :approved, :approved_period, :approve_group, :return_dtr]
  def index
    @submissions = ApiClient.my_dtr_submissions(session[:token]).body["submissions"]
  end

  def show
    @data = ApiClient.dtr_submission(session[:token], params[:id]).body
    Rails.logger.info "DTR SHOW DEBUG: #{@data.inspect}"
  end

  def pending
    @groups = ApiClient.pending_dtrs(session[:token]).body["pending_groups"]
  end

  def approve_group
    response = ApiClient.approve_dtr_group(session[:token], params[:period_start], params[:period_end])
    if response.success?
      redirect_to pending_dtr_submissions_path, notice: response.body["message"]
    else
      redirect_to pending_dtr_submissions_path, alert: response.body["error"]
    end
  end

  def return_dtr
    response = ApiClient.return_dtr(session[:token], params[:id], params[:return_reason])
    if response.success?
      redirect_to pending_dtr_submissions_path, notice: response.body["message"]
    else
      redirect_to pending_dtr_submissions_path, alert: response.body["error"]
    end
  end

def pending
  @groups = ApiClient.pending_dtrs(session[:token]).body["pending_groups"]
end

def pending_period
  @groups = ApiClient.pending_dtrs(session[:token]).body["pending_groups"]
  @group = @groups.find { |g| g["period_start"] == params[:period_start] && g["period_end"] == params[:period_end] }
  return if @group.nil?

  @employees_data = @group["submissions"].map do |s|
    ApiClient.dtr_submission(session[:token], s["id"]).body
  end
end  

def approved
  @groups = ApiClient.approved_dtrs(session[:token]).body["approved_groups"]
end

def approved_period
  @groups = ApiClient.approved_dtrs(session[:token]).body["approved_groups"]
  @group = @groups.find { |g| g["period_start"] == params[:period_start] && g["period_end"] == params[:period_end] }
  return if @group.nil?

  @employees_data = @group["submissions"].map do |s|
    ApiClient.dtr_submission(session[:token], s["id"]).body
  end
end

  private

  def require_approver
    unless current_user && %w[manager hr admin].include?(current_user["role"])
      redirect_to root_path, alert: "Not authorized."
    end
  end
end
