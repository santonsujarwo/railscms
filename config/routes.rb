Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    root "dashboard#index"
    resources :pages
  end
  get "/up" => "rails/health#show", as: :rails_health_check
  root "public/pages#home"
  get "*path", to: "public/pages#show", constraints: ->(request) { !request.path.start_with?("/rails/") }
end
