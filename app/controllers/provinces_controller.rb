class ProvincesController < ApplicationController
  before_action :set_province, only: %i[ show edit update destroy ]

  # GET /provinces or /provinces.json
  def index
    @provinces = Province.all
    render json: @provinces
  end

  # GET /provinces/1 or /provinces/1.json
  def show
    render json: @province
  end

  # GET /provinces/new
  def new
    @province = Province.new
  end

  # GET /provinces/1/edit
  def edit
  end

  # POST /provinces or /provinces.json
  def create
    @province = Province.new(province_params)

    if @province.save
      render json: @province, status: :created, location: @province
    else
      render json: @province.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /provinces/1 or /provinces/1.json
  def update
    if @province.update(province_params)
      render json: @province
    else
      render json: @province.errors, status: :unprocessable_entity
    end
  end

  # DELETE /provinces/1 or /provinces/1.json
  def destroy
    @province.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_province
      @province = Province.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def province_params
      params.require(:province).permit(:name, :population)
    end
end
