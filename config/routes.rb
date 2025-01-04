Rails.application.routes.draw do
  # OmniAuth routes
  get "/auth/google_oauth2/callback", to: "sessions#oauth_callback"
  get "/auth/failure", to: "sessions#failure"
  get "/auth/google_oauth2", to: "sessions#oauth_request", as: :oauth_request

  # Session routes
  resource :session, only: [ :new, :create, :destroy ]
  delete "/logout", to: "sessions#destroy", as: :logout

  # Registration routes
  resources :registrations, only: [ :new, :create ] do
    member do
      get "verify_otp"
      post "verify_otp"
      post :resend_otp
    end
  end
  get "search", to: "application#search"

  namespace :usermodule do
    
    resources :orders, only: [ :index, :show, :update ] do
      patch :cancel, on: :member
      patch :update_address, on: :member
    end

    resource :cart, only: [ :show, :destroy ] do
      post "add_to_cart", on: :collection
    end

    resources :checkouts, only: [ :new, :create, :edit, :update ] do
      collection do
        post :apply_coupon
      end
      member do
        get :confirmation, as: :order_confirmation
        patch :update_status
        patch :confirm_payment
      end
    end

    resources :users, only: [ :edit, :update ]

    resources :addresses do
      collection do
        get :get_states
        get :get_cities
      end
    end

    resources :home, only: [ :index ]

    # Add standalone products resource for general search
    resources :products, only: [ :index ] do
      get :search, on: :collection
    end

    # Modified categories structure
    resources :categories, only: [ :index, :show ] do
      resources :subcategories, only: [ :index, :show ] do
        resources :products, only: [ :index, :show ] do
          collection do
            get :search  
          end
          resources :productviews, only: [ :index ]
        end
      end
    end
  end


  # Admin namespace
  namespace :admin do
    resources :users do
      member do
        patch :toggle_block
      end
    end
    resources :orders, only: [ :index, :show, :update ] do
      member do
        patch :cancel
        patch :edit_address
        patch :update_address
      end
  end

    resources :products do
      get :subcategories, on: :collection
    end
    resources :categories
    resources :subcategories
    get "dashboard", to: "dashboard#index"
  end

  # ActionCable route for WebSocket connections
  mount ActionCable.server => "/cable"

  # Root path
  root "registrations#new"

  # Optional favicon route
  get "/favicon.ico", to: "application#favicon"
end
