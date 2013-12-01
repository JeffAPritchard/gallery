Gallery::Application.routes.draw do
  root :to => "construction#index"
  devise_for :users
end
