class AreasController < ApplicationController
  def index
    @areas = ApiClient.areas(session[:token]).body["areas"]
  end

  def new
    @users = ApiClient.users(session[:token]).body["users"]
  end

  def create
    response = ApiClient.create_area(session[:token], area_params.to_h)
    if response.success?
      redirect_to areas_path, notice: "Area created successfully."
    else
      @users = ApiClient.users(session[:token]).body["users"]
      flash.now[:alert] = response.body["error"] || "Could not create area."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @area = ApiClient.area(session[:token], params[:id]).body["area"]
    @users = ApiClient.users(session[:token]).body["users"]
  end

  def update
    response = ApiClient.update_area(session[:token], params[:id], area_params.to_h)
    if response.success?
      redirect_to areas_path, notice: "Area updated successfully."
    else
      @area = ApiClient.area(session[:token], params[:id]).body["area"]
      @users = ApiClient.users(session[:token]).body["users"]
      flash.now[:alert] = response.body["error"] || "Could not update area."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def area_params
    params.require(:area).permit(:name, :code, :approver_id).tap do |p|
      p[:approver_id] = nil if p[:approver_id].blank?
    end
  end
end
