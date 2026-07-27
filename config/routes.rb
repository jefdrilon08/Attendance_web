Rails.application.routes.draw do
  get "dashboard/index"

  root "dashboard#index"

  get  "login",  to: "sessions#new"
  post "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"


  
  
  resources :users, only: [:index, :new, :create, :show, :edit, :update] do
    member do
      patch :toggle_branch
    end
  end
  
  resources :users do
    resources :leave_balances, controller: "employee_leave_balances", only: [:create]
  end
  resources :employee_leave_balances, only: [:update]

  resources :positions, only: [:index]
  resources :branches, only: [:index, :new, :create, :edit, :update]
  resources :clusters, only: [:index, :new, :create, :show, :edit, :update]
  resources :areas, only: [:index, :new, :create, :edit, :update]
  resources :organization_structures, only: [:index, :new, :create, :edit, :update]
  resources :positions, only: [:index, :new, :create, :edit, :update]
get   "dtr/pending", to: "dtr_submissions#pending", as: :pending_dtr_submissions
get   "dtr/approved", to: "dtr_submissions#approved", as: :approved_dtr_submissions
get   "dtr/approved/period", to: "dtr_submissions#approved_period", as: :approved_period_dtr_submissions
patch "dtr/approve_group", to: "dtr_submissions#approve_group", as: :approve_group_dtr_submissions
patch "dtr/:id/return", to: "dtr_submissions#return_dtr", as: :return_dtr_submission
get   "dtr", to: "dtr_submissions#index", as: :dtr_submissions
get   "dtr/:id", to: "dtr_submissions#show", as: :dtr_submission
get "dtr/pending/period", to: "dtr_submissions#pending_period", as: :pending_period_dtr_submissions
resources :leave_types, only: [:index, :new, :create, :edit, :update]


#get "sessions/new"
  #get "sessions/create"
  #get "sessions/destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
