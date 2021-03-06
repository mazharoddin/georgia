Georgia::Engine.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, class_name: "Georgia::User", path: '/', module: 'georgia/users', path_names: {sign_in: '/login', sign_out: '/logout'}

  namespace :api do
    resources :media, only: [] do
      collection do
        get :pictures
      end
    end
    resources :tags, only: [:index] do
      get :search, on: :collection
    end
  end

  Georgia::PageableRouteConcern.included(self)

  resources :pages, concerns: [:pageable]

  resources :media, path: :media do
    collection do
      get :search
      post :download
      delete '/', to: :destroy
    end
  end
  resources :users do
    get 'permissions', on: :collection
  end
  resources :menus, path: 'navigation'
  resources :links, only: [:create, :show]
  resources :widgets
  resources :ui_associations, path: 'ui-associations', only: [:new]
  resources :slides, only: [:new]

  # unauthenticated do
  #   as :user do
  #     root to: 'users/sessions#new'
  #   end
  # end
  root to: "dashboard#show"

end
