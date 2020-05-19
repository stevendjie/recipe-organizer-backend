Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :recipes
    end
  end

  post 'refresh', controller: :refresh, action: :create
  post 'login', controller: :login, action: :create
  delete 'login', controller: :login, action: :destroy
  post 'signup', controller: :signup, action: :create

  get 'settings', controller: :settings, action: :show
  patch 'settings', controller: :settings, action: :update

  get 'send_shopping_list', controller: :shopping_list, action: :send_mail
end
