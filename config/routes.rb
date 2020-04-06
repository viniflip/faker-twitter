Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :users, only: %i[index create show] do
        get '/me' => 'users#current', on: :collection
        post :login, on: :collection
        post :change_password, on: :collection
        post :follow, on: :member
        post :unfollow, on: :member
      end
      resources :posts, only: %i[create index show]

    end
  end
end
