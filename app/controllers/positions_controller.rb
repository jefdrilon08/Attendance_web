class PositionsController < ApplicationController
  def index
    @positions = ApiClient.positions(session[:token]).body["positions"]
  end

  def new
    load_form_options
  end

  def create
    response = ApiClient.create_position(session[:token], position_params.to_h)
    if response.success?
      redirect_to positions_path, notice: "Position created successfully."
    else
      load_form_options
      flash.now[:alert] = response.body["error"] || "Could not create position."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @position = ApiClient.position(session[:token], params[:id]).body["position"]
    load_form_options
  end

  def update
    response = ApiClient.update_position(session[:token], params[:id], position_params.to_h)
    if response.success?
      redirect_to positions_path, notice: "Position updated successfully."
    else
      @position = ApiClient.position(session[:token], params[:id]).body["position"]
      load_form_options
      flash.now[:alert] = response.body["error"] || "Could not update position."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_form_options
    @organization_structures = ApiClient.organization_structures(session[:token]).body["organization_structures"]
  end

  def position_params
    params.require(:position).permit(:name, :organization_structure_id)
  end
end
