Gallery::Application.routes.draw do
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
