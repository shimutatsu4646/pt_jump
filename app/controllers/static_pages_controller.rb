class StaticPagesController < ApplicationController
  def top
    @trainees = Trainee.all
    @trainers = Trainer.all
  end
end
