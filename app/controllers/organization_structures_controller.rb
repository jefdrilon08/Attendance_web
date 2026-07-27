class OrganizationStructuresController < ApplicationController
  def index
    @organization_structures = ApiClient.organization_structures(session[:token]).body["organization_structures"]
  end

  def new
  end

  def create
    response = ApiClient.create_organization_structure(session[:token], org_params.to_h)
    if response.success?
      redirect_to organization_structures_path, notice: "Organization structure created successfully."
    else
      flash.now[:alert] = response.body["error"] || "Could not create organization structure."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @organization_structure = ApiClient.organization_structure(session[:token], params[:id]).body["organization_structure"]
  end

  def update
    response = ApiClient.update_organization_structure(session[:token], params[:id], org_params.to_h)
    if response.success?
      redirect_to organization_structures_path, notice: "Organization structure updated successfully."
    else
      @organization_structure = ApiClient.organization_structure(session[:token], params[:id]).body["organization_structure"]
      flash.now[:alert] = response.body["error"] || "Could not update."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def org_params
    params.require(:organization_structure).permit(:name)
  end
end
