ScreenGuide4::Application.routes.draw do
  root to: 'pages#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/login' => 'sessions#destroy'

  resources :users, only: [:new, :create]
  
  namespace :account do
    get '/', to: :show
    patch :update
    patch :change_password

    get :shows
  end

  namespace :admin do
    get '/', to: :index
    resources :users, only: [:index, :edit, :update, :destroy]
    resources :shows, only: [:index, :edit, :update, :destroy]
    resources :seasons, only: [:index, :edit, :update, :destroy]
    resources :episodes, only: [:index, :edit, :update, :destroy]
  end
end