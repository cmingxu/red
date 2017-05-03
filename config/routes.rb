Rails.application.routes.draw do
  resources :registries
  resources :images
  resources :service_templates

  resources :groups
  resources :users

  namespace :api do
    resources :nodes  do
    end

    resource :mesos, only: [:show], controller: :mesos, action: :index
  end

  resources :apps

  resources :nodes do
    resources :containers, only: [:index, :show]  do
      member do
        patch :start
        patch :stop
        patch :kill
        patch :restart
        patch :pause
        patch :resume
        patch :remove

        get :stats
        get :logs
        get :console
      end
    end
    resources :images, only: [:index, :show]
    resources :networks, only: [:index, :show]
    resources :volumes, only: [:index, :show]
  end

  put 'toggle_locale', controller: :application
  
  get 'welcome/index'
  get 'mesos/index', as: :mesos

  resources :services

  root to: "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
