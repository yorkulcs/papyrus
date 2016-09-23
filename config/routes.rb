Papyrus::Application.routes.draw do



  namespace :students do
  get 'permanent_delete/destroy'
  end

  get "stats" => "stats#index"
  get "stats/assigned_students" =>"stats#assigned_students"
  get "stats/item_usage" => "stats#item_usage"
  get "stats/items_history" => "stats#items_history"

  get "dashboard" => "home#index"
  get "active_users" => "home#active_users", as: :active_users

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"

  # Scan List & Items
  resources :scan_lists do
    resources :scan_items, except: :index
  end

  resource :settings, only: [:update] do
    get :general
    get :email
    get :bib_search
    get :item
    get :system
    get :acquisitions
  end

  # Anouncements
  resources :announcements do
    get "hide", on: :member
  end

  # match 'announcements/:id/hide', to: 'announcements#hide', as: 'hide_announcement'
  # Download document link
  get "documents/download/:id" => "documents#download", as: :download_document

  # Student View
  match "login_as_student/:id" => "student_view#login_as_student", :as => :admin_student_view, via: [:get, :post]
  match "logout_as_student" => "student_view#logout_as_student", :as => :logout_as_student, via: [:get, :post]
  get "my/" => "student_view#show", :as => :student_view
  get "my/details" => "student_view#details", :as => :student_view_details
  match "my/terms" => "student_view#index", :as => :show_student_terms, via: [:get, :post]
  match "my/accept_terms" => "student_view#accept_terms", :as => :accept_student_terms, via: [:get, :post]
  match "my/access_codes" => "student_view#access_codes", as: :student_view_access_codes, via: [:get, :post]

  resources :users do
    post "activate", :on => :member
    get "audit_trail", :on => :member
    get "inactive", :on => :collection
  end

  ## Special path for documents to work across the board
  resources :courses do
    resources :documents, path: "syllabus"
  end


  resources :terms do
     resources :courses do
        post "add_item", :on => :member
        post "assign_to_item", :on => :collection
        post "remove_item", :on => :member
     end
     get "search_courses", :on => :collection
  end

  resources :shared_access_codes, only: [:index, :new, :create, :destroy]

  namespace :students do
    resources :permanent_delete, only: [:index, :show, :destroy]
  end

  resources :students do
    resources :documents
    resources :access_codes
    resources :notes, except: [:show, :new]

    resource :student_details, as: :details, path: "details", except: [:index, :destroy]

    collection do
      get "inactive"
      #get "search"
      post "notify"
    end

    member do
      get 'items'
      post "send_welcome_email"
      get "audit_trail"
      get :block
      get :unblock
      get :reactivate
      get :complete_orientation

      post :enroll_in_courses
      delete :withdraw_from_course
    end
  end

  resources :items do
    get 'renew_access', on: :member
    post 'assign_to_students', on: :member
    post 'assign_many_to_student', on: :collection
    delete 'withhold_from_student', on: :member
    get "courses", on: :member
    get "audit_trail", on: :member
    get 'zipped_files', on: :member
    get 'acquisition_requests', on: :member
    get 'scan_lists', on: :member
    #get 'search', :on => :collection
    #get 'search_vufind', :on => :collection
    resources :attachments, path: "files", except: [:index, :show] do
      get 'get_file', on: :member
      post 'delete_multiple', on: :collection
    end

  end

  resources :acquisition_requests do
    patch :change_status, on: :member
    get :change_status_form, on: :member
    post :send_to_acquisitions, on: :member
    get :status, on: :collection
  end

  # Search
  match "search/items(/:type)" => "search#items", as: "search_items", via: :get,  defaults: { type: "local" }
  match "search/students(/:type)" => "search#students", as: "search_students", via: :get,  defaults: { type: "active" }
  match "search" => "search#index", as: "search", via: :get
  # Root
  root :to => "home#index"

end
