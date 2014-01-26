Gallery::Application.routes.draw do

  # root :to => "construction#index"
  root :to => "home#index"

  # home related stuff
  get 'home/replace_about_section/:tab' => 'home#replace_about_section'
  
  get 'index' => 'home#index'

  get 'bio_blurb' => 'home#bio_blurb', :as => :bio_blurb
  get 'home/bio_blurb' => 'home#bio_blurb'
  
  get 'skillz_blurb' => 'home#skillz_blurb', :as => :skillz_blurb
  get 'home/skillz_blurb' => 'home#skillz_blurb'
  
  get 'website_blurb' => 'home#website_blurb', :as => :website_blurb
  get 'home/website_blurb' => 'home#website_blurb'
  
  get 'display/:category', to: 'activities#display', :as => :display
  get 'activities/display' => 'activities#display'




  # photo gallery stuff
  get 'photos/using_jscript/:size' => 'photos#using_jscript'
  get 'photos/remember_tab/:tab' => 'photos#remember_tab'
  get 'photos/new_page/:href' => 'photos#new_page'
  get 'photos/large/:id' => 'photos#large'
  resources :photos






  resources :categories

  resources :activities

  
  
  devise_for :users
  
  
  
  
end
