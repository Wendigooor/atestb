App::Application.routes.draw do
  get "about/index"

  devise_for :clients
    
  root :to => "pages#home"

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
      post :add_credits
    end
  end

  resources :users do
    collection do
      get :excel
      get :count
    end
  end
  
  # resources :developers

  # resources :sdkkeys do
  #   collection do
  #     get :activate
  #     get :update_placements
  #   end
  # end

  resources :clients do
    resources :profiles, only: [:show, :edit, :update]
    resources :campaigns
    resources :sdkkeys
    collection do
      get :settings
    end
  end

end
