Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Landing page layout — the simulation form lives here (FE-01+).
  resources :simulations, only: [ :new ]

  # magicagem blog scaffold — whimsy-palette preview, separate from the You-Bet brand.
  namespace :blog do
    resources :sessions, only: [ :index, :show ]
    get "about", to: "pages#about"
    get "archive", to: "pages#archive"
  end

  # Defines the root path route ("/")
  root "home#index"
end
