class BranchesController < ApplicationController
  def index
    response = ApiClient.branches(session[:token])
    @branches = response.body["branches"]
  end

  def new
    load_form_options
  end

  def create
    response = ApiClient.create_branch(session[:token], branch_params.to_h)

    if response.success?
      redirect_to branches_path, notice: "Branch created successfully."
    else
      load_form_options
      flash.now[:alert] = response.body["error"] || "Could not create branch."
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    @branch = ApiClient.branch(session[:token], params[:id]).body["branch"]
    load_form_options
  end

  def update
    response = ApiClient.update_branch(session[:token], params[:id], branch_params.to_h)
    if response.success?
      redirect_to branches_path, notice: "Branch updated successfully."
    else
      @branch = ApiClient.branch(session[:token], params[:id]).body["branch"]
      load_form_options
      flash.now[:alert] = response.body["error"] || "Could not update branch."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_form_options
    @users = ApiClient.users(session[:token]).body["users"]
    @clusters = ApiClient.clusters(session[:token]).body["clusters"]
  end

  def branch_params
    params.require(:branch).permit(:name, :short_code, :latitude, :longitude, :allowed_radius, :cluster_id, :approver_id).tap do |p|
      p[:cluster_id] = nil if p[:cluster_id].blank?
      p[:approver_id] = nil if p[:approver_id].blank?
    end
  end

end
