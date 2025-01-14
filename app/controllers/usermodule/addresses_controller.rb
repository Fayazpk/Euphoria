module Usermodule
  class AddressesController < ApplicationController
    before_action :set_address, only: %i[show edit update destroy]
    before_action :authenticate_user!
    before_action :load_countries, only: %i[new edit create update]

    def index
      @addresses = current_user.addresses
    end

    def show
    end

    def new
      @address = current_user.addresses.new
      @states = []
      @cities = []
    end

    def edit
      @states = @address.country&.states || []
      @cities = @address.state&.cities || []
    end

    def create
      @address = current_user.addresses.build(address_params)
      
      respond_to do |format|
        if @address.save
          format.html { redirect_to usermodule_address_path(@address), notice: "Address was successfully created." }
          format.json { render :show, status: :created, location: @address }
        else
        
          @states = @address.country&.states || []
          @cities = @address.state&.cities || []
          
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      
      respond_to do |format|
        if @address.update(address_params)
          format.html { redirect_to usermodule_address_path(@address), notice: "Address was successfully updated." }
          format.json { render :show, status: :ok, location: @address }
        else
         
          @states = @address.country&.states || []
          @cities = @address.state&.cities || []
          
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @address.destroy!

      respond_to do |format|
        format.html { redirect_to usermodule_addresses_path, notice: "Address was successfully destroyed." }
        format.json { head :no_content }
      end
    end


def get_states
  begin
    states = State.where(country_id: params[:country_id])
                  .select(:id, :name)
                  .order(:name)
                  Rails.logger.info(states)

    render json: states
  rescue => e
    render json: { error: "Failed to load states" }, status: :unprocessable_entity
  end
end

def get_cities
  begin
    cities = City.where(state_id: params[:state_id])
                 .select(:id, :name)
                 .order(:name)
    render json: cities
  rescue => e
    render json: { error: "Failed to load cities" }, status: :unprocessable_entity
  end
end

    private

    def set_address
      @address = current_user.addresses.find(params[:id])
    end

    def load_countries
      @countries = Country.all
    end

    def address_params
      params.require(:address).permit(
        :first_name, :last_name, :building_name, 
        :street_address, :country_id, :state_id, 
        :city_id, :phone
      )
    end
  end
end