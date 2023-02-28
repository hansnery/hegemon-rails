require 'hegemon/province_utils'

class MapsController < ApplicationController
  before_action :set_map, only: %i[ show edit update destroy ]

  # GET /maps or /maps.json
  def index
    @maps = Map.all
  end

  # GET /maps/1 or /maps/1.json
  def show
    @provinces = @map.provinces.all.includes(:nearby_provinces)
    @provinces_json = @provinces.to_json(include: :nearby_provinces)
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
    @map.num_players = @map.max_players

    respond_to do |format|
      if @map.save
        format.html { redirect_to map_url(@map), notice: "Map was successfully created." }
        format.json { render :show, status: :created, location: @map }

        # Load and parse GeoJSON local file
        file_path = Rails.root.join('provinces.geojson')
        file_contents = File.read(file_path)
        data = JSON.parse(file_contents)

        # Loop through the FeatureCollection to create Ruby objects from it
        data['features'].map do |feature|
          province = Province.new
          province.name = feature['properties']['name']
          # province.geometry = feature['geometry']['coordinates']
          province.map_id = @map.id
          province.armies = 1
          province.save
        end

        # Divide the territories equally among the number of players
        provinces_with_owners = Hegemon::ProvinceUtils.set_province_owners(@map.provinces, @map.num_players)

        # Save the provinces with owners to the database
        provinces_with_owners.each do |province|
          province.save
        end

        # Assign neighbouring provinces to provinces so that armies can move
        Hegemon::ProvinceUtils.set_nearby_provinces(@map.provinces)
        format.json { render json: @map.nearby_provinces }
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

  def marches_to
    @map = Map.find(params[:id])
    @province_1 = Province.find(params[:province_1_id])
    @province_2 = Province.find(params[:province_2_id])

    if @province_1.owner == @province_2.owner
      @province_1.armies -= 1
      @province_2.armies += 1
      # @result = "Marched one army from Province 1 to Province 22."
    else
      # @result = "It would require an attack."
    end

    @province_1.save
    @province_2.save

    @provinces = @map.provinces.all.includes(:nearby_provinces)
    @provinces_json = @provinces.to_json(include: :nearby_provinces)

    render json: @provinces_json
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
