ScreenGuide::Application.routes.draw do
  root to: 'pages#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/login' => 'sessions#destroy'

  resources :users, only: [:create]
  resources :shows, only: [:index, :show] do
    resources :seasons, only: [:index]
    member do
      post :watch
    end
  end
  resources :seasons, only: [:show]
  resources :episodes, only: [:show] do
    member do
      post :watch
    end
  end
  
  namespace :account do
    get '/', to: :show
    patch :update
    patch :change_password
    get :queue
  end

  namespace :admin do
    resources :users, only: [:index, :edit, :update, :destroy]
    resources :shows, except: [:show, :index] do
      resources :seasons, only: [:new, :create]
      collection do
        post :rage_create
      end
      member do
        post :check_for_new_episodes
      end
    end
    resources :seasons, except: [:show, :index] do
      resources :episodes, only: [:new, :create]
    end
    resources :episodes, except: [:show, :index]
  end
end