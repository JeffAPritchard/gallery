Gallery::Application.routes.draw do

  root :to => "construction#index"

  # home related stuff
  get 'index' => 'home#index'
  get 'bio_blurb' => 'home#bio_blurb', :as => :bio_blurb
  get 'home/bio_blurb' => 'home#bio_blurb'
  
  get 'website_blurb' => 'home#website_blurb', :as => :website_blurb
  get 'home/website_blurb' => 'home#website_blurb'
  
  get 'display/:category', to: 'activities#display', :as => :display
  get 'activities/display' => 'activities#display'





  # photo gallery stuff
  get 'photos/using_jscript/:width' => 'photos#using_jscript'
  get 'photos/remember_tab/:tab' => 'photos#remember_tab'
  get 'photos/new_page/:href' => 'photos#new_page'
  resources :photos






  resources :categories

  resources :activities

  
  
  devise_for :users
  
  
  
  
end
