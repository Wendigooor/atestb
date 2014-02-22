App::Application.routes.draw do
  get "about/index"

  devise_for :clients, :controllers => { :registrations => "registrations" }
    
  root :to => "pages#home"
  
  # match 'rest/fetch' => 'rest_api#fetch'
  # match 'rest/submit' => 'rest_api#submit'
  # match 'rest/notification' => 'rest_api#notification'
  # match 'rest/user_identify' => 'rest_api#user_identify'
  # match 'rest/user_check' => 'rest_api#user_check'
  # match 'rest/ad_shown' => 'rest_api#ad_shown'
  # match 'rest/upload_picture' => 'rest_api#upload_picture'
  # match 'rest/delete_picture' => 'rest_api#delete_picture'

  #post 'clients/add_money'
  get  'clients/settings' #!!!

  # get  'campaigns/unapproved'
  # get  'campaigns/select_type'
  # post 'campaigns/after_create'
  # get  'campaigns/audience'
  # get  'campaigns/target'

  #post 'purchases/minimal_purchase'

  #get 'sdkkeys/:id/users', to: 'sdkkeys#users', as: 'sdkkey_users'

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

  resources :purchases do
    collection do
      post :minimal_purchase
    end
  end

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

end
