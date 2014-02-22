App::Application.routes.draw do
  get "about/index"

  devise_for :clients, :controllers => { :registrations => "registrations" }
    
  root :to => "pages#home"
  
  match 'rest/fetch' => 'rest_api#fetch'
  match 'rest/submit' => 'rest_api#submit'
  match 'rest/notification' => 'rest_api#notification'
  match 'rest/user_identify' => 'rest_api#user_identify'
  match 'rest/user_check' => 'rest_api#user_check'
  match 'rest/ad_shown' => 'rest_api#ad_shown'
  match 'rest/upload_picture' => 'rest_api#upload_picture'
  match 'rest/delete_picture' => 'rest_api#delete_picture'

  post 'clients/add_money'
  get  'clients/settings'

  get  'campaigns/unapproved'
  get  'campaigns/select_type'
  post 'campaigns/after_create'
  get  'campaigns/audience'
  get  'campaigns/target'

  post 'purchases/minimal_purchase'

  get 'sdkkeys/:id/users', to: 'sdkkeys#users', as: 'sdkkey_users'

  resources :campaigns do
    resources :locations
    resources :approves
    resources :activates

    get :campaign_items
    get :before_answers
    get :before_answers_table
    get :remove_campaign_before
    collection do
      get :excel
      get :search
    end
  end

  resources :campaign_location_points do
    collection do
      get :coordinates
    end
  end

  resources :adv_periods

  resources :purchases
  resources :users do
    collection do
      get :excel
      get :count
    end
  end
  
  resources :developers

  resources :statistics do
    collection do
      get :global_statistic
      get :user_campaign_clicks_statistic
    end
  end

  resources :sdkkeys do
    collection do
      get :activate
      get :update_placements
    end
  end

  resources :clients do
    resources :profiles
    resources :campaigns do
      resources :statistics do
        collection do
          get :answered_users
          get :excel
         end
      end
    end
    resources :sdkkeys
  end

  resources :contact
  resources :blogs

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
