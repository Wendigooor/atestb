App::Application.routes.draw do
  get "about/index"

  devise_for :clients
    
  root :to => "pages#home"

  #get 'clients/settings' #!!!

  resources :rest do
    collection do
      get  :fetch
      get  :notification
      post :submit
      post :user_identify
      post :user_check
      post :ad_shown
      post :upload_picture
      post :delete_picture
    end 
  end

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

end
