Rails.application.routes.draw do

  # get 'sessions/new'
  # get 'sessions/create'
  # get 'sessions/destroy'
  get 'home/index'
  get 'sessions/logout_user'
  resources :user_profiles
  resources :notes
  resources :sessions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "sessions#index"

end
