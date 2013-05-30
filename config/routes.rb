require 'api_constraints'

Kanari::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :redemptions
      resources :outlets
      resources :payment_invoices, only: [:index]

      resources :customers do
        resources :payment_invoices, only: [:create]
      end
      resources :feedbacks
      resources :social_network_accounts
    end
  end

  devise_for :users, path: '/api/users',controllers: {
    sessions: 'api/v1/custom_devise/sessions',
    invitations: 'api/v1/custom_devise/invitations',
    passwords: 'api/v1/custom_devise/passwords'
  }

  root :to => "home#index"
end
