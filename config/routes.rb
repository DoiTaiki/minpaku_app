Rails.application.routes.draw do
  get 'users/new'
  root 'static_pages#home'
  get 'static_pages/home'
  get 'users/sign_up', to: 'users#new'
  get 'users/account', to: 'users#show'
  resource :user do
    collection do
      get 'user/sign_in', to: 'users#sign_in'
      post 'user/sign_in', to: 'users#session_create'
      get 'user/profile'
      post 'user/logout'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
