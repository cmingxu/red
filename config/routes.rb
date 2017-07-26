Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'search/owner_search'
  get 'search/list_owner'

  get 'system/index', as: :system
  get 'system/info', as: :system_info
  patch 'system/update_marathon_config', as: :update_marathon_config
  patch 'system/update_mesos_config', as: :update_mesos_config
  patch 'system/update_domain_config', as: :update_domain_config
  patch 'system/update_swan_config', as: :update_swan_config
  patch 'system/update_registry_domain_config', as: :update_registry_domain_config
  patch 'system/update_graphna_config', as: :update_graphna_config

  get 'session/new', as: :new_session
  get 'session/particles'
  post 'session/create', as: :login
  delete 'session/destroy', as: :logout

  get 'settings/account', as: :setting
  get 'settings/group', as: :settings_group
  get 'settings/third', as: :settings_third

  post 'registry/notifications', as: :notifications
  get 'registry/token', as: :token

  get 'welcome/index', as: :dashboard

  resources :namespaces do
    resources :permissions

    resources :repositories do
      resources :repo_tags, only: [:show, :destroy] do
        member do
          put :vulnerabilities_check
          get :manifest_blob_page
        end
      end
    end

    resources :projects do
    end
  end

  resources :builds, only: [:create]
  resources :pods

  resources :audits, only: [:index]
  resources :versions
  resources :service_templates do
    resources :permissions do
    end
  end

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
        get :stats_json
        get :logs
        get :console
      end
    end
    resources :images, only: [:index, :show] do
      member do
        patch :push
        patch :pull
        post  :tag
      end
    end
    resources :networks, only: [:index, :show] do
      member do
        delete :leave_from_network
      end
    end
    resources :volumes, only: [:index, :show]
  end

  put 'toggle_locale', controller: :application
  put 'set_main_content_width', controller: :application

  get 'welcome/index'
  get 'mesos/index', as: :mesos
  get 'marathon/index', as: :marathon
  get 'swan/index', as: :swan
  get 'graphna/index', as: :graphna_stats

  get 'mesos/ping', as: :ping_mesos
  get 'marathon/ping', as: :ping_marathon
  get 'graphna/ping', as: :ping_graphna_stats

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
        put :swan_scale_up
        put :swan_scale_down

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
