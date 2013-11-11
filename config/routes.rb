Georgia::Engine.routes.draw do

  devise_for :users,
  class_name: "Georgia::User",
  path: '/',
  module: :devise,
    path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'},
    controllers: {sessions: "georgia/users/sessions", registrations: "georgia/users/registrations"}

  devise_scope :user do
    get '/logout', to: 'users/sessions#destroy'
  end

  namespace :api do
    resources :media, only: [] do
      collection do
        get :pictures
      end
    end
    resources :tags, only: [] do
      get :search, on: :collection
    end
  end

  concern :pageable do

    collection do
      post :sort
      get :search
    end

    member do
      get :draft
      get :publish
      get :unpublish
      get :copy
      get :settings
      post 'flush-cache', to: :flush_cache, as: :flush_cache
    end

    resources :revisions do
      member do
        get :preview
        get :review
        get :approve
        get :store
        get :decline
        get :restore
      end
    end
  end

  resources :pages, concerns: [:pageable]

  resources :media, path: :media do
    collection do
      get :search
      post :download
    end
  end
  resources :users
  resources :messages do
    collection do
      get :search
      get :destroy_all_spam
    end
    member do
      get :spam
      get :ham
    end
  end
  resources :menus
  resources :links, only: [:new]
  resources :widgets
  resources :ui_associations, path: 'ui-associations', only: [:new]
  resources :slides, only: [:new]

  match '/search/messages', to: 'search#messages'

  root :to => "dashboard#show"

end
