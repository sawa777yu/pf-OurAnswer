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
  # get 'search', to: 'searches/search'

  scope module: :public do
    resources :users, only: [:edit, :update, :show] do
      collection do
        get 'confirm'
        patch 'withdraw'
      end
      resources :relationships, only: [:create, :destroy] 
      get 'followings', to: 'relationships#followings', as: 'followings'
      get 'followers', to: 'relationships#followers', as: 'followers'
    end

    resources :posts, except: [:index, :destroy] do
      collection do
        get 'bookmarks'
      end
      resources :bookmarks, only: [:create, :destroy]
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
