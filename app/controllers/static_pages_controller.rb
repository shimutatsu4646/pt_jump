class StaticPagesController < ApplicationController
  def top
    @trainees = Trainee.includes(:prefectures, :cities, :day_of_weeks).with_attached_avatar.all
    @trainers = Trainer.includes(:prefectures, :cities, :day_of_weeks).with_attached_avatar.all
  end
end
