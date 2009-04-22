ActionController::Routing::Routes.draw do |map|
  map.resources :users

  map.resource :session

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "groups"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.resource :session
  map.resources :sources
  map.resources :rawstories, :collection => {:filter_by_opinions => :get,:filter_by_videos => :get, :search => :get, :show_all => :get, :sort_by_relevance => :get, :sort_by_time => :get}
  map.resources :authors
  map.resources :subscriptions, :collection => {:get_alerts => :get, :stop_alerts => :get}
  map.resources :groups, :collection => {:opinions => :get, :politics => :get, :culture => :get, :science => :get, :business => :get, :sport => :get, :mixed => :get, :humor => :get, :technology => :get}
  map.resources :users
  map.resources :haufens
  map.resources :topics, :collection => {:delete => :get}
  map.resources :about, :collection => {:imprint => :get, :privacy => :get, :feedback => :get}
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy', :l => @l
  map.settings '/settings', :controller => 'users', :action => 'settings'
  map.search_rawstories ':l', :controller => 'rawstories', :action => 'search'
  
  
  
  

end
