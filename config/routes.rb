Rails.application.routes.draw do
  root 'static_pages#top'
  # devise_for :スコープの設定対象, module: "対応するコントローラ"
  devise_for :trainees, module: "trainees"

  # devise_scope は,deviseに新しくルーティングを追加したいときに使用する。
  # devise_scope :trainee do
  #   root "trainees/registrations#profile"
  # end

  # devise_scope :trainer do
  #   root "trainers/registrations#profile"
  # end
end
