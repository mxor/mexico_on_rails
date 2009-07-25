ActionController::Routing::Routes.draw do |map|
  map.resources :mailbox, :collection => {:trash => :get}
  map.resources :sent
  map.resources :messages, :member => {:reply => :get, :forward => :get, :restore => :put}
  map.resources :quick_tips
  map.resources :comments, :collection => {:destroy_multiple => :delete}, :member => {:approve => :put, :disapprove => :put}
  map.resources :pages, :collection => {:sort => :post}, :member => {:publish => :put, :unpublish => :put}
  map.resources :apps
  map.resources :news
  map.resources :uploads
  map.resources :articles, :member => {:rate => :post}
  map.resources :users, :has_many => [:articles, :apps], :requirements => { :id => /.*/ }
  map.resource :session
  map.root :news_index

  map.inbox 'inbox', :controller => 'mailbox', :action => 'index'
  map.tags ':controller/tags/:tag'

  map.with_options :controller => 'sessions' do |sessions|
    sessions.logout 'logout', :action => 'destroy'
    sessions.login 'login', :action => 'new'
  end
  
  map.with_options :controller => 'users' do |users|
    users.signup 'signup', :action => 'new'
    users.forgot 'forgot', :action => 'forgot'
    users.reset 'reset/:reset_code', :action => 'reset'
    users.activate 'activate/:activation_code', :action => 'activate', :activation_code => nil
    users.account 'account', :action => 'edit', :id => nil
    users.profile ':id', :action => 'show', :requirements => { :id => /.*[^\/]/ }
  end
end
