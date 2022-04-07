Rails.application.routes.draw do
  root 'static_pages#top'

  devise_for :trainees, module: "trainees"
  devise_scope :trainee do
    get 'trainees/show/:id', to: 'trainees#show', as: :trainee
    get 'trainees/edit_profile/:id', to: 'trainees#edit', as: :edit_profile_trainee
    put 'trainees/update_profile/:id', to: 'trainees#update', as: :update_profile_trainee
    get 'trainees/search', to: 'trainees#search', as: :search_for_trainee
  end

  devise_for :trainers, module: "trainers"
  devise_scope :trainee do
    get 'trainers/show/:id', to: 'trainers#show', as: :trainer
    get 'trainers/edit_profile/:id', to: 'trainers#edit', as: :edit_profile_trainer
    put 'trainers/update_profile/:id', to: 'trainers#update', as: :update_profile_trainer
    get 'trainers/search', to: 'trainers#search', as: :search_for_trainer
  end

  resources :chats, only: [:index, :show, :create]
end
