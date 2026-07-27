class ClustersController < ApplicationController
  def index
    @clusters = ApiClient.clusters(session[:token]).body["clusters"]
  end

  def new
    load_form_options
  end

  def create
    response = ApiClient.create_cluster(session[:token], cluster_params.to_h)

    if response.success?
      redirect_to clusters_path, notice: "Cluster created successfully."
    else
      load_form_options
      flash.now[:alert] = response.body["error"] || "Could not create cluster."
      render :new, status: :unprocessable_entity
    end
  end
  def show
    response = ApiClient.cluster(session[:token], params[:id])
    @cluster = response.body["cluster"]
  end

  def edit
    @cluster = ApiClient.cluster(session[:token], params[:id]).body["cluster"]
    load_form_options
  end

  def update
    response = ApiClient.update_cluster(session[:token], params[:id], cluster_params.to_h)
    if response.success?
      redirect_to clusters_path, notice: "Cluster updated successfully."
    else
      @cluster = ApiClient.cluster(session[:token], params[:id]).body["cluster"]
      load_form_options
      flash.now[:alert] = response.body["error"] || "Could not update cluster."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_form_options
    @areas = ApiClient.areas(session[:token]).body["areas"]
    @organization_structures = ApiClient.organization_structures(session[:token]).body["organization_structures"]
    @users = ApiClient.users(session[:token]).body["users"]
  end

  def cluster_params
    params.require(:cluster).permit(:name, :area_id, :organization_structure_id, :approver_id).tap do |p|
      p[:area_id] = nil if p[:area_id].blank?
      p[:organization_structure_id] = nil if p[:organization_structure_id].blank?
      p[:approver_id] = nil if p[:approver_id].blank?
    end
  end

end
