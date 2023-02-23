class MapsController < ApplicationController
  before_action :set_map, only: %i[ show edit update destroy ]

  # GET /maps or /maps.json
  def index
    @maps = Map.all
  end

  # GET /maps/1 or /maps/1.json
  def show
    @provinces = @map.provinces.all
    @provinces_json = @provinces.to_json
  end

  # GET /maps/new
  def new
    @map = Map.new
  end

  # GET /maps/1/edit
  def edit
  end

  # POST /maps or /maps.json
  def create
    @map = Map.new(map_params)

    @map.name = "Roman Empire"
    @map.min_players = 2

    respond_to do |format|
      if @map.save
        format.html { redirect_to map_url(@map), notice: "Map was successfully created." }
        format.json { render :show, status: :created, location: @map }

        file_path = Rails.root.join('provinces.geojson')
        file_contents = File.read(file_path)
        data = JSON.parse(file_contents)

        data['features'].map do |feature|
          province = Province.new
          province.name = feature['properties']['name']
          province.geometry = feature['geometry']['coordinates']
          province.map_id = @map.id
          province.armies = 1
          province.save
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maps/1 or /maps/1.json
  def update
    respond_to do |format|
      if @map.update(map_params)
        format.html { redirect_to map_url(@map), notice: "Map was successfully updated." }
        format.json { render :show, status: :ok, location: @map }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maps/1 or /maps/1.json
  def destroy
    @map.destroy

    respond_to do |format|
      format.html { redirect_to maps_url, notice: "Map was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_map
      @map = Map.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def map_params
      params.require(:map).permit(:name, :min_players, :max_players, :num_players)
    end
end
