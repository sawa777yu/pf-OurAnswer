Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions:      'public/publics/sessions',
    passwords:     'public/publics/passwords',
    registrations: 'public/publics/registrations'
  }

  devise_for :admins, controllers: {
    sessions:      'admin/admins/sessions',
  }

  root to: 'public/homes#top'
  get 'about', to: 'public/homes#about'
  get 'search', to: 'searches#search'
  get 'search_genre', to: 'searches#search_genre'
  resources :notifications, only: :index do
    collection do
      delete 'destroy_all'
    end
  end
  resources :contacts, only: [:new, :create] do
    collection do
      post 'confirm'
      post 'back'
      get 'done'
    end
  end

  scope module: :public do
    resources :users, only: [:edit, :update, :show] do
      collection do
        get 'confirm'
        patch 'withdraw'
        post 'guest_sign_in', to: 'users#new_guest'
      end
      get :bookmarks
      resource :relationships, only: [:create, :destroy]
      get 'followings', to: 'relationships#followings', as: 'followings'
      get 'followers', to: 'relationships#followers', as: 'followers'
    end

    resources :posts, except: [:index, :destroy] do
      resource :bookmarks, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end
  end

  namespace :admin do
    root 'homes#top'
    resources :users, only: [:edit, :update, :show]
    resources :posts, except: [:new, :index, :create]
    resources :genres, except: [:new, :destroy]
  end

end
