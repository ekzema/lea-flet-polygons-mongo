Rails.application.routes.draw do
  root :to => 'welcome#index'
  get 'welcome/index'

  namespace :api do
    resources :polygons
  end
end
