module Admin
    class DashboardController < ApplicationController
      layout 'admin'
      before_action :authenticate_admin
  
      def index
        render :index
      end
  
      private
  
      def authenticate_admin
        unless current_user&.admin?
          redirect_to new_session_path, alert: "You must be an admin to access this area"
        end
      end
    end
  end
  