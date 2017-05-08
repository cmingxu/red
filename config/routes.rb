Rails.application.routes.draw do
  get 'system/index', as: :system
  get 'rbac/index', as: :rbac

  get 'session/new', as: :new_session
  get 'session/particles'
  post 'session/create', as: :login
  delete 'session/destroy', as: :logout

  get 'settings/account', as: :setting
  get 'settings/group', as: :setting_group
  get 'settings/autit', as: :setting_audit

  resources :registries
  resources :images
  resources :service_templates

  resources :groups do 
    resources :users
    member do
      put :update_quota
    end
  end

  resources :users do
    member do
      put :update_quota
    end
  end


  namespace :api do
    resources :nodes  do
    end

    resource :mesos, only: [:show], controller: :mesos, action: :index
  end


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

  resources :services do
    resources :apps do
      member do
        put :run
        put :stop
      end
    end

    member do
      post :save_as_template
      put :favorite
      put :unfavorite
      get :download_compose
    end
  end

  root to: "services#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
