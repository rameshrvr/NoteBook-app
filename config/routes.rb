Rails.application.routes.draw do

  get 'sessions/logout_user'
  get 'notes/update_visibility'

  resources :user_profiles

  resources :sessions

  resources :notes do
    member do
      get :send_mail
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "sessions#index"

end
