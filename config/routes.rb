Rails.application.routes.draw do
  get 'users/new'
  root 'static_pages#home'
  get 'static_pages/home'
  get 'user/sign_up', to: 'users#new'
  get 'user/account', to: 'users#show'
  delete 'user/:id/destroy_by_admin', to: 'users#destroy_by_admin'
  resource :user do
    collection do
      get 'profile'
      patch 'profile', to: 'users#profile_update'
      get 'sign_in'
      post 'sign_in', to: 'users#session_create'
      delete 'logout'
      get 'all_users'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
