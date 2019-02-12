Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
      resources :sessions do
        collection do
          post 'log_in', to: 'sessions#log_in'
        end
      end
      resources :transfers do
        collection do
          post 'deposit', to: 'transfers#deposit'
        end
      end
    end
  end
end
