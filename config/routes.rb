Rails.application.routes.draw do
  resources :namespaces
  get 'search/owner_search'
  get 'search/list_owner'

  resources :permissions
  get 'system/index', as: :system

  get 'session/new', as: :new_session
  get 'session/particles'
  post 'session/create', as: :login
  delete 'session/destroy', as: :logout

  get 'settings/account', as: :setting
  get 'settings/group', as: :setting_group

  post 'registry/notifications', as: :notifications

  resources :audits, only: [:index]
  resources :versions
  resources :service_templates

  resources :groups do
    resources :users do
      member do
        delete :leave
        patch :update_quota_cpu
        patch :update_quota_mem
        patch :update_quota_disk
      end
    end

    member do
      patch :update_quota_cpu
      patch :update_quota_mem
      patch :update_quota_disk
    end

  end

  resources :users do
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
        put :start
        put :restart
        put :change
        put :rollback
        put :scale

        get :backend_state
        get :detail
      end

      resources :versions
    end

    resources :permissions do
    end

    member do
      post :save_as_template
      put :favorite
      put :unfavorite
      post :download_compose
      get :compose_chose
    end
  end

  root to: "services#index"
end
