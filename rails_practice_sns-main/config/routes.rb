Rails.application.routes.draw do

  post "likes/:post_id/create" => "likes#create"
  post "likes/:post_id/destroy"  => "likes#destroy"
  # resources :likes, params: :post_id, only: [:create, :destroy]

  get "login" => "users#login_form"
  post "login" => "users#login" 
  get "logout" => "users#logout"
  
  post "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  get "signup" => "users#new"
  get 'users/index' => "users#index"
  get "users/:id" => "users#show"
  get "users/:id/likes" => "users#likes"

  resources :posts
  resources :words
  # resources :follows, only: [:create]

  post "follows/:target_user_id" => "follows#create"
  post "follows/:target_user_id/destroy" => "follows#destroy"
  
  # フォローしているUser一覧
  get "follows" => "follows#follows"
  # フォロワーのUser一覧
  get "followers" => "follows#followers"
  
  get "/" => "home#top"
  get "about" => "home#about"
end
