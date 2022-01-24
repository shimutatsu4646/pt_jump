Rails.application.routes.draw do
  root 'static_pages#top'

  devise_for :trainees, module: "trainees"
  devise_scope :trainee do
    get 'trainees/show/:id', to: 'trainees#show', as: :trainee
  end
end
