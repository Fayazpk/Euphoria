module Usermodule
  class AddressesController < ApplicationController
    before_action :set_address, only: %i[show edit update destroy]
    before_action :authenticate_user!
    before_action :load_countries, only: %i[new edit]

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
          load_countries
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
          load_countries
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @address.destroy!

      respond_to do |format|
        format.html { redirect_to usermodule_addresses_path, status: :see_other, notice: "Address was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def get_states
      country = Country.find(params[:country_id])
      states = country.states.select(:id, :name)
      render json: states
    end

    def get_cities
      state = State.find(params[:state_id])
      cities = state.cities.select(:id, :name)
      render json: cities
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