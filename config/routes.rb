Rails.application.routes.draw do

  resources :users
  resources :prescriptions
  resources :drugs
  resources :patients
  root to: 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
