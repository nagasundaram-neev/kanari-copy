require 'api_constraints'

Kanari::Application.routes.draw do

  scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
    devise_for :users, path: '/api/users',controllers: {
      sessions: 'api/v1/custom_devise/sessions',
      invitations: 'api/v1/custom_devise/invitations',
      passwords: 'api/v1/custom_devise/passwords',
      registrations: 'api/v1/custom_devise/registrations'
    }
  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :redemptions, only: [:create, :index]
      resources :outlets
      resources :payment_invoices, only: [:index]
      resources :managers, only: [:create, :index]
      resources :staffs, only: [:create, :index]
      resources :cuisine_types, only: [:index, :show, :create, :update, :destroy]
      resources :outlet_types, only: [:index, :show, :create, :update, :destroy]
      resources :kanari_codes, only: [:show, :create]

      resources :customers do
        resources :payment_invoices, only: [:create]
      end
      resources :feedbacks
      resources :social_network_accounts
      resources :users, :only => [:index]
      resources :new_registration_points, :only => [:create]
      get "/users/invitation/:invitation_token" => "invitations#show"
    end
  end

  root :to => "home#index"
end
