Rails.application.routes.draw do
  # OmniAuth routes
  get '/auth/google_oauth2/callback', to: 'sessions#oauth_callback'
  get '/auth/failure', to: 'sessions#failure'
  get '/auth/google_oauth2', to: 'sessions#oauth_request', as: :oauth_request 

  # Session routes
  resource :session, only: [:new, :create, :destroy]
  delete "/logout", to: "sessions#destroy", as: :logout

  # Registration routes
  resources :registrations, only: [:new, :create] do
    member do
      get "verify_otp"
      post "verify_otp"
      post :resend_otp
    end
  end

  # Usermodule namespace
  namespace :usermodule do
    resources :users, only: [:edit, :update]
    resources :addresses do
      collection do
        get :get_states
        get :get_cities
      end
    end
    resources :home, only: [:index]
    resources :categories, only: [:index, :show] do
      resources :subcategories, only: [:index] do
        resources :products, only: [:index, :show] do
          resources :productviews, only: [:index]
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