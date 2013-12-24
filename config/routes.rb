require 'api_constraints'

Kanari::Application.routes.draw do

  scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
    devise_for :users, path: '/api/users',controllers: {
      sessions: 'api/v1/custom_devise/sessions',
      invitations: 'api/v1/custom_devise/invitations',
      passwords: 'api/v1/custom_devise/passwords',
      registrations: 'api/v1/custom_devise/registrations',
      confirmations: 'api/v1/custom_devise/confirmations'
    }
  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :redemptions, only: [:create, :index,:update]
      resources :outlets do
        member do
          put 'disable'
        end
      end
      resources :payment_invoices, only: [:index]
      resources :managers, only: [:show, :create, :index, :destroy, :update]
      resources :staffs, only: [:create, :index, :destroy, :update]
      resources :cuisine_types, only: [:index, :show, :create, :update, :destroy]
      resources :outlet_types, only: [:index, :show, :create, :update, :destroy]
      resources :kanari_codes, only: [:show, :create]

      resources :customers do
        resources :payment_invoices, only: [:create]
      end
      resources :feedbacks, :only => [:index, :update]
      resources :social_network_accounts
      resources :users, :only => [:index]
      resources :activities, :only => [:index]
      resources :audit_logs, :only => [:index]
      resources :new_registration_points, :only => [:create]
      get "/users/invitation/:invitation_token" => "invitations#show"
      devise_scope :user do
        get "/users/confirmation/:confirmation_token" => "custom_devise/confirmations#redirect", as: 'confirmation_mail'
      end
      get "/feedbacks/metrics" => "feedbacks#metrics"
      get "/feedbacks/trends"  => "feedbacks#trends"
      put "/feedbacks/user_reachout/:id" => "feedbacks#user_reachout"
      get "/feedbacks/user_response/:id" => "feedbacks#user_response"      
    end
  end

  root :to => "home#index"
end
