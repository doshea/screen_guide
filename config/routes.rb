ScreenGuide4::Application.routes.draw do
  root to: 'pages#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/login' => 'sessions#destroy'

  resources :users, only: [:new, :create]
  resources :shows, only: [:index, :show] do
    resources :seasons, only: [:index]
  end
  resources :seasons, only: [:show] do
    resources :episodes, only: [:index]
  end
  resources :episodes, only: [:show]
  
  namespace :account do
    get '/', to: :show
    patch :update
    patch :change_password

    get :shows
  end

  namespace :admin do
    resources :users, only: [:index, :edit, :update, :destroy]
    resources :shows, except: [:show, :index]
    resources :seasons, except: [:show, :index]
    resources :episodes, except: [:show, :index]
  end
end