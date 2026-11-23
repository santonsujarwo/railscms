Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root "dashboard#index"
    resources :pages, only: %i[index new create edit update destroy] do
      resources :sections, only: %i[create edit update destroy]
    end
  end

  get "/up" => "rails/health#show", as: :rails_health_check
  root "public/pages#home"
  get "*path", to: "public/pages#show", constraints: ->(request) { !request.path.start_with?("/rails/") }
end
