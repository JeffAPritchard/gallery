Gallery::Application.routes.draw do



  # photo gallery stuff
  get 'photos/previous_photo', to: 'photos#previous_photo', :as => :previous_photo
  get 'photos/previous_photo' => 'photos#previous_photo'
  
  get 'photos/next_photo', to: 'photos#next_photo', :as => :next_photo
  get 'photos/next_photo' => 'photos#next_photo'


  resources :photos

  resources :categories

  resources :activities

  root :to => "construction#index"
  
  get 'index' => 'home#index'
  
  devise_for :users
  
  get 'bio_blurb' => 'home#bio_blurb', :as => :bio_blurb
  get 'home/bio_blurb' => 'home#bio_blurb'
  
  
  get 'website_blurb' => 'home#website_blurb', :as => :website_blurb
  get 'home/website_blurb' => 'home#website_blurb'
  
  get 'display/:category', to: 'activities#display', :as => :display
  get 'activities/display' => 'activities#display'
  
  
  
end
