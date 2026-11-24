Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root "dashboard#index"
    resource :global_style, only: %i[edit update]
    resources :section_definitions, only: %i[index edit] do
      resources :field_definitions, only: %i[create update destroy]
    end
    resources :pages, only: %i[index new create edit update destroy] do
      resources :sections, only: %i[create edit update destroy] do
        member do
          patch :move
          patch :toggle
        end
      end
      resources :revisions, controller: "page_revisions", only: [] do
        member { patch :restore }
      end
    end
    resources :posts do
      resources :revisions, controller: "post_revisions", only: [] do
        member { patch :restore }
      end
    end
    resources :categories
    resources :media_assets, path: "media"
  end

  get "/up" => "rails/health#show", as: :rails_health_check
  root "public/pages#home"
  get "/posts/:slug", to: "public/posts#show", as: :public_post
  get "*path", to: "public/pages#show", constraints: ->(request) { !request.path.start_with?("/rails/") }
end
