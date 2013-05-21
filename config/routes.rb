require 'api_constraints'

Kanari::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :redemptions
      resources :outlets
      resources :payment_invoices
      resources :customers
      resources :feedbacks
      resources :social_network_accounts
    end
  end

  devise_for :users, path: '/api/users',controllers: {
    sessions: 'api/v1/custom_devise/sessions',
    invitations: 'api/v1/custom_devise/invitations'
  }

  root :to => "home#index"
end
