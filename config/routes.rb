Rails.application.routes.draw do
  root 'static_pages#top'

  devise_for :trainees, module: "trainees"
  devise_scope :trainee do
    get 'trainees/show/:id', to: 'trainees#show', as: :trainee
  end

  devise_for :trainers, module: "trainers"
  devise_scope :trainee do
    get 'trainers/show/:id', to: 'trainers#show', as: :trainer
  end
end
