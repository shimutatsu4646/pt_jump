Rails.application.routes.draw do
  root 'static_pages#top'

  devise_for :trainees, module: "trainees"
  get 'trainees/show/:id', to: 'trainees#show', as: :trainee
  get 'trainees/edit_profile/:id', to: 'trainees#edit', as: :edit_profile_trainee
  put 'trainees/update_profile/:id', to: 'trainees#update', as: :update_profile_trainee
  get 'trainees/search', to: 'trainees#search', as: :search_for_trainee

  devise_for :trainers, module: "trainers"
  get 'trainers/show/:id', to: 'trainers#show', as: :trainer
  get 'trainers/edit_profile/:id', to: 'trainers#edit', as: :edit_profile_trainer
  put 'trainers/update_profile/:id', to: 'trainers#update', as: :update_profile_trainer
  get 'trainers/search', to: 'trainers#search', as: :search_for_trainer

  resources :chats, only: [:index, :show, :create]

  resources :contracts, except: [:new, :edit]
  get 'contracts/new/:id', to: 'contracts#new', as: :new_contract

  resources :candidates, only: [:index]
  post 'candidates/:id', to: 'candidates#create', as: :create_candidate
  delete 'candidates/:id', to: 'candidates#destroy', as: :destroy_candidate

  resources :reviews, except: [:index, :new, :destroy]
  get 'reviews/index/:id', to: 'reviews#index', as: :index_reviews
  get 'reviews/new/:id', to: 'reviews#new', as: :new_review
end
