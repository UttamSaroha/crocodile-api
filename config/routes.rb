Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations"}

  root 'pages#home'
resources :user, param: :username, controller: "users", shallow: true, only: :show do
  resources :posts, only: [:show, :edit, :update, :create, :destroy] do
    resources :comments, only: [:index, :edit, :update, :create, :destroy]
  end
  member do
    get 'friends'
    get 'avatar'
  end
end
  resource :avatar, only: [:update, :show]
resources :friendships, only: [:create, :destroy]
resources :friend_requests, only: [:create, :destroy] do
  collection do
    get :sent, :received
  end
end

get 'users', to: 'users#index' , as: :users
  get 'edit_profile', to: 'users#edit', as: :edit_profile
  put 'update_profile', to: 'users#update', as: :update_profile
  post 'likes/:likeable_type/:likeable_id', to: 'likes#like', as: "like"
  delete 'likes/:likeable_type/:likeable_id', to: 'likes#unlike', as: "unlike"
get '/search', to: 'users#search'







end
