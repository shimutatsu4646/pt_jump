class CandidatesController < ApplicationController
  before_action :authenticate_trainee!
  before_action :set_trainer, only: [:create, :destroy]

  def index
    @candidates = current_trainee.trainer_candidates.
      includes(:prefectures, :cities).
      with_attached_avatar.
      order("candidates.created_at DESC")
  end

  def create
    @candidate = Candidate.new(trainee_id: current_trainee.id, trainer_id: @trainer.id)
    @candidate.save
  end

  def destroy
    @candidate = Candidate.find_by(trainee_id: current_trainee.id, trainer_id: @trainer.id)
    @candidate.destroy
  end

  private

  def set_trainer
    @trainer = Trainer.find(params[:id])
  end
end
