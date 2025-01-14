class CountriesController < ApplicationController
    def index
        render :json => State.(params[:country])
    end
end
