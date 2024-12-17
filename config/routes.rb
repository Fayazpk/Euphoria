Rails.application.routes.draw do
  # OmniAuth routes
  get '/auth/:provider', to: 'sessions#oauth_request', as: :auth_request
  get '/auth/:provider/callback', to: 'sessions#oauth_callback'
  get '/auth/failure', to: redirect('/')

  # Session routes
  resource :session, only: [:new, :create, :destroy]
  delete '/logout', to: 'sessions#destroy', as: :logout

  # Registration routes
  resources :registrations, only: [:new, :create] do
    member do
      get 'verify_otp'
      post 'verify_otp'
    end
  end

  # Usermodule namespace
  namespace :usermodule do
    resources :home, only: [:index]
    resources :categories, only: [:index, :show] do
      resources :subcategories, only: [:index] do
        resources :products, only: [:index]
      end
    end
  end

  # Admin namespace
  namespace :admin do
    resources :products do
      get :subcategories, on: :collection
    end
    resources :categories
    resources :subcategories
    get 'dashboard', to: 'dashboard#index'
  end

  # Root path
  root 'registrations#new'
end
