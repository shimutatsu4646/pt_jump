class ReviewsController < ApplicationController
  before_action :authenticate_trainee!, except: [:index]
  before_action :check_login, only: [:index]
  before_action :check_contract_conclusion, only: [:new, :create]

  def index
    @trainer = Trainer.find(params[:id])
    @reviews = @trainer.reviews.order("reviews.updated_at DESC")
    if trainee_signed_in?
      @review = Review.find_by(trainee_id: current_trainee.id, trainer_id: @trainer.id)
      @decided_contracts = Contract.where(trainee_id: current_trainee.id, trainer_id: @trainer.id, final_decision: true)
    end
  end

  def new
    @trainer = Trainer.find(params[:id])
    @review = Review.new
  end

  def create
    @review = Review.new(create_review_params)
    if @review.save
      trainer = Trainer.find(@review.trainer.id)
      redirect_to trainer_path(trainer.id)
      flash[:notice] = "レビューを投稿しました。"
    else
      @trainer = Trainer.find(@review.trainer.id)
      render :new
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(update_review_params)
      trainer = @review.trainer
      flash[:notice] = "レビューを編集しました。"
      redirect_to trainer_path(trainer.id)
    else
      render :edit
    end
  end

  private

  def create_review_params
    params.require(:review).permit(:title, :comment, :star_rate, :trainer_id).
      merge(
        trainee_id: current_trainee.id
      )
  end

  def update_review_params
    params.require(:review).permit(:title, :comment, :star_rate)
  end

  def check_contract_conclusion
    trainer = Trainer.find(params[:id])
    decided_contracts = Contract.where(trainee_id: current_trainee.id, trainer_id: trainer.id, final_decision: true)
    if decided_contracts.empty?
      flash[:notice] = "契約成立していないトレーナーのレビューを投稿することはできません。"
      redirect_to trainer_path(trainer.id)
    end
  end

  def check_login
    trainer = Trainer.find(params[:id])
    if trainer_signed_in? == false && trainee_signed_in? == false
      flash[:notice] = "ログインユーザーのみ閲覧可能です。"
      redirect_to trainer_path(trainer.id)
    end
  end
end
