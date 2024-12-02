Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :create ]

      post "auth/login", to: "authentication#login"

      resources :files, only: [ :create, :index ]
    end
  end
end
