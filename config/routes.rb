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
    get '/iati' => 'iati#index'
    get '/iati/published' => 'iati#published_organizations', :as => 'iati_published_organizations'
    get '/iati/publisher' => 'iati#publisher', :as => 'iati_publisher'
    post '/iati/sync' => 'iati#sync', :as => 'iati_sync'
    # match '/report' => 'reports#index', :as => :report_index
    # match '/report_generate' => 'reports#report', :as => :report_generate
    resources :settings, :only => [:edit, :update]
    resources :users do
      put 'disable', :action => 'disable'
      put 'enable', :action => 'enable'
    end
    resources :geolocations do
	post 'reassign', :action => 'reassign'
        resources :projects, :only => [:index]
    end
    resources :tags do
       resources :projects, :only => [:index] 
    end
    resources :stories
    resources :regions, :only => [:index]
    resources :organizations do
      resources :projects, :only => [:index]
      resources :media_resources, :only => [:index, :create, :update, :destroy]
      resources :resources, :only => [:index, :create, :destroy, :update]
      get 'specific_information/:site_id', :on => :member, :action => 'specific_information', :as => 'organization_site_specific_information'
      put 'destroy_logo', :on => :member
      resource :activity
    end
    resources :donors, :only => [] do
      resources :media_resources, :only => [:index, :create, :update, :destroy]
      resources :resources, :only => [:index, :create, :destroy]
      resources :offices, :only => [:index]
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
#     resources :pages
    resources :projects_synchronizations, :only => [:create, :update]
    resources :layers
  end

  if Rails.env.development?
    mount IatiMailer::Preview => 'mail_view_iati'
    mount AlertsMailer::Preview => 'mail_view'
  end
end
