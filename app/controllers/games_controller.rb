require 'hegemon/province_utils'

class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]
  after_action :create_map, only: [:create]

  # GET /games or /games.json
  def index
    @games = Game.all
  end

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
    @map = Map.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    # Create Game object
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: "Game was successfully created." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to game_url(@game), notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      # params.require(:game).permit(:name, :private, map_attributes: [:min_players, :max_players, :num_players])
      # params.require(:game).permit(:name, :private, map_attributes: [:min_players, :max_players])
      params.require(:game).permit(:name, :private)
    end

    def create_map
      # Set parameters
      map_params = params[:map]

      @map = Map.new

      @map.name = "Roman Empire"
      @map.min_players = 2
      @map.max_players = map_params[:max_players]
      @map.num_players = @map.max_players
      @map.game = @game
      @map.save

      create_players

      create_provinces
    end

    def create_players
      players_params = []
      params.each do |key, value|
        if key.start_with?("player_")
          player_name = value
          players_params << value
        end
      end

      # Create player objects based on the number of players selected in the form
      players_params.each do |player_name|
        player = Player.new
        player.name = player_name
        player.map_id = @map.id
        player.color = "#" + SecureRandom.hex(3)
        player.save
      end
    end

    def create_provinces
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
        province.armies = 5
        province.save
      end

      # Divide the territories equally among the number of players
      provinces = @map.provinces
      players = @map.players.to_a
      shuffled_provinces = provinces.shuffle.each_slice((provinces.size.to_f / players.size).ceil)

      shuffled_provinces.each_with_index do |slice, player_index|
        player = players[player_index]
        slice.each do |province|
          province.player_id = player.id
          province.owner = player.name
          province.color = player.color
          province.save
        end
      end

      # Assign neighbouring provinces to provinces so that armies can move
      Hegemon::ProvinceUtils.set_nearby_provinces(@map.provinces)
    end
end
