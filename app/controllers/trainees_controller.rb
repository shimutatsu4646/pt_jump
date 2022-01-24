class TraineesController < ApplicationController
  def show
    @trainee = Trainee.find(params[:id])
  end
end
