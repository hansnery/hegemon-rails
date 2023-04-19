require 'hegemon/province_utils'

class MapsController < ApplicationController
  before_action :set_map_and_game, only: %i[ show edit update destroy ]

  # GET /maps or /maps.json
  def index
    @maps = Map.all
  end

  # GET /maps/1 or /maps/1.json
  def show
    @provinces = @map.provinces.all
    @provinces_json = @map.provinces.all.to_json(include: :nearby_provinces)

    respond_to do |format|
      format.html
      format.json { render json: @provinces_json }
    end
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
    @num_armies = (params[:num_armies]).to_i

    if @province_1.owner == @province_2.owner && @province_1 != @province_2
      @province_2.armies += @num_armies
      @province_1.armies -= @num_armies
    end

    if @province_1.owner != @province_2.owner
      attacker_dice_rolls = []

      if @num_armies >= 3
        roll_dice(3, attacker_dice_rolls)
      else
        roll_dice(@num_armies, attacker_dice_rolls)
      end

      attacker_dice_rolls.sort.reverse!

      defender_dice_rolls = []

      if @province_2.armies >= 3
        roll_dice(3, defender_dice_rolls)
      else
        roll_dice(@province_2.armies, defender_dice_rolls)
      end

      defender_dice_rolls.sort.reverse!

      attacker_dice_rolls.zip(defender_dice_rolls).each do |attacker_roll, defender_roll|
        if attacker_roll && defender_roll
          if attacker_roll > defender_roll
            @province_2.armies -= 1
            puts "\n"
            puts "*********************************************************************************"
            puts "#{@province_1.owner} defeats 1 army of #{@province_2.owner}"
            puts "*********************************************************************************"
            puts "\n"
            if @province_2.armies == 0
              conquer_province(@province_1, @province_2, @num_armies)
            end
          else
            @province_1.armies -= 1
            @num_armies -= 1
            puts "\n"
            puts "*********************************************************************************"
            puts "#{@province_2.owner} defeats 1 army of #{@province_1.owner}"
            puts "*********************************************************************************"
            puts "\n"
          end
        elsif attacker_roll
          conquer_province(@province_1, @province_2, @num_armies) if @province_2.owner != @province_1.owner
        end
      end

      puts "\n"
      puts "*********************************************************************************"
      puts "Attacker dice rolls: #{attacker_dice_rolls.sort.reverse}"
      puts "Defender dice rolls: #{defender_dice_rolls.sort.reverse}"
      puts "*********************************************************************************"
      puts "\n"
    end

    @province_1.save
    @province_2.save

    @provinces = @map.provinces.all.includes(:nearby_provinces)
    @provinces_json = @provinces.to_json(include: :nearby_provinces)

    render json: @provinces_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_map_and_game
      @map = Map.find(params[:id])
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def map_params
      params.require(:map).permit(:min_players, :max_players, :num_players)
    end

    # Rolls a 6 sided die a number of times and store in an array
    def roll_dice(number_of, array)
      number_of.times do
        array << rand(1..6)
      end
    end

    def conquer_province(attacker_province, defender_province, num_armies)
      puts "\n"
      puts "*********************************************************************************"
      puts "#{attacker_province.owner} conquered #{defender_province.name} from #{defender_province.owner}"
      puts "*********************************************************************************"
      puts "\n"
      defender_province.owner = attacker_province.owner
      defender_province.color = attacker_province.color
      defender_province.armies = num_armies
      attacker_province.armies -= num_armies
    end
end
