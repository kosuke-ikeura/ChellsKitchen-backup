# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'top#index'
  resources :flavors do
    collection do
      get 'search'
    end
  end
  resources :users do
    member do
      get 'image'
    end
  end
end
