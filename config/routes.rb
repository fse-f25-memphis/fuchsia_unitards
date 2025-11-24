Rails.application.routes.draw do
 
  devise_for :users

  # Root – homepage
  root "unitards#index"

  resources :unitards do
    resources :reviews, only: %i[new create]
    post :toggle_wishlist, on: :member
  end

  resource :cart, only: [:show] do
    post "add/:unitard_id", to: "carts#add", as: :add_to
    patch "update/:id", to: "carts#update", as: :update_item
    delete "remove/:id", to: "carts#remove", as: :remove_item
  end

  resources :orders, only: [:index, :show, :create] do
    collection do
      get 'checkout'
      post 'place_order'
    end
    member do
      get 'payment'
      post 'process_payment'
      get 'success'
    end
  end

  resources :trades, only: %i[index show new create update]

  resources :wishlist_items, only: %i[index destroy]

  resources :support_tickets, only: %i[new create show]

  namespace :vendor do
    root "dashboard#index"
    resources :unitards
    resource :inventory, only: %i[show update]
    resources :payments, only: %i[index show]
    resources :discounts, only: %i[index new create]
    resources :messages, only: %i[index show create]
    resources :analytics, only: [:index]
  end
  resources :reviews, only: [:new, :create, :index, :show]
  resources :orders do
  member do
    patch :complete
  end
end
end
