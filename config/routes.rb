Iom::Application.routes.draw do

  # Home
  root :to => "admin/admin#index"

  # Session
  resource :session, :only => [:new, :create, :destroy]
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout

  resource :passwords

  # Administration
  namespace :admin do
    match '/' => 'admin#index', :as => :admin
    match '/export_projects' => 'admin#export_projects', :as => :export_projects
    match '/export_organizations' => 'admin#export_organizations', :as => :export_organizations
    # match '/report' => 'reports#index', :as => :report_index
    # match '/report_generate' => 'reports#report', :as => :report_generate
    resources :settings, :only => [:edit, :update]
    resources :users do
      put 'disable', :action => 'disable'
      put 'enable', :action => 'enable'
    end
    resources :geolocations, :only => [:index]
    resources :tags, :only => [:index]
    resources :regions, :only => [:index]
    resources :organizations do
      resources :projects, :only => [:index]
      resources :media_resources, :only => [:index, :create, :update, :destroy]
      resources :resources, :only => [:index, :create, :destroy, :update]
      get 'specific_information/:site_id', :on => :member, :action => 'specific_information', :as => 'organization_site_specific_information'
      put 'destroy_logo', :on => :member
      resource :activity
    end
    resources :donors do
      resources :media_resources, :only => [:index, :create, :update, :destroy]
      resources :resources, :only => [:index, :create, :destroy]
      resources :offices, :only => [:index]
      get 'projects', :on => :member
      get 'specific_information/:site_id', :on => :member, :action => 'specific_information', :as => 'donor_site_specific_information'
      put 'destroy_logo', :on => :member
    end
    resources :offices do
      get 'projects', :on => :member
    end
    resources :projects do
      resources :media_resources, :only => [:index, :create, :update, :destroy]
      resources :resources, :only => [:index, :create, :destroy, :update]
      get 'donations', :on => :member
      resources :donations, :only => [:create, :destroy]
      resource :activity
    end
    resources :sites do
      get 'customization', :on => :member
      get 'projects', :on => :member
      post 'toggle_status', :on => :member
      put 'destroy_aid_map_image', :on => :member
      put 'destroy_logo', :on => :member
      resources :partners, :only => [:create, :destroy]
      resources :media_resources, :only => [:index, :create, :update, :destroy]
      resources :resources, :only => [:index, :create, :destroy, :update]
      resources :pages
    end
    resource :activity
    resources :changes_history_records, :controller => "activities"
    resources :pages
    resources :projects_synchronizations, :only => [:create, :update]
    resources :layers
  end

  if Rails.env.development?
    mount AlertsMailer::Preview => 'mail_view'
  end
end
