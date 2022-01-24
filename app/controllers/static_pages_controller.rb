class StaticPagesController < ApplicationController
  def top
    @trainees = Trainee.all
  end
end
