EfarDispatch::Application.routes.draw do

  resource :account
  resource :session
  resources :efars do
    collection do
      get 'expired'
      get 'nyc' # not yet competent
      get 'active'
      get 'search'
      get 'bibbed'
    end
    member do
      post 'text_message'
    end
  end

  # Admin resources
  namespace :admin do
    resource :session
    resources :admins
    resources :community_centers
    resources :managers
    resources :efars do
      collection do
        get 'map'
        get 'expired'
        get 'nyc' # not yet competent
        get 'active'
        get 'search'
        get 'bibbed'
        get 'alert_subscriber'
        get 'near'
      end
      member do
        post 'text_message'
      end
    end
    resources :activity_logs
  end
  match 'admin/' => 'admin/efars#index'

  resources :text_messages
  resources :study_invites do
    member do
      get 'accept'
      get 'reject'
    end
    collection do
      get 'accepted'
      get 'pending'
    end
  end
  resources :alerts do
    collection do
      get 'efars_map'
    end
  end
  

  match 'clickatell/' => 'clickatell#callback'

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
  match 'admin/efars' => 'admin/efars#index', as: :admin_root
  root :to => 'efars#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
