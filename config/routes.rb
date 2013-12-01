Gallery::Application.routes.draw do
  root :to => "construction#index"
  
  get 'index' => 'home#index'
  
  devise_for :users
end
