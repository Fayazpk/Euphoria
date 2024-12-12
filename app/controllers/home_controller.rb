class HomeController < ApplicationController
    def index
        Rails.logger.info("Home page accessed")  # Debugging line
        # You can add any logic needed for the home page here
    end
    
   
end
