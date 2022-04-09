class TrainersController < ApplicationController
  before_action :check_current_trainer, only: [:edit, :update]
  before_action :check_for_searching_trainer, only: [:search]

  def show
    @trainer = Trainer.includes(:prefectures, :cities, :day_of_weeks).with_attached_avatar.find(params[:id])
    if trainee_signed_in?
      @undecided_contracts = current_trainee.contracts.where(trainer_id: @trainer.id, final_decision: false)
      @decided_contracts = current_trainee.contracts.where(trainer_id: @trainer.id, final_decision: true)
    end
  end

  def edit
    @trainer = current_trainer
    @regions = Region.includes(:prefectures, :cities).all
  end

  def update
    @trainer = current_trainer
    if @trainer.update(trainer_profile_params)
      flash[:notice] = "プロフィール情報を変更しました。"
      redirect_to trainer_path(@trainer)
    else
      render :edit
    end
  end

  def search
    @trainer_search_params = trainer_search_params
    @trainers = Trainer.includes(:prefectures, :cities, :day_of_weeks).with_attached_avatar.search_trainer(@trainer_search_params)
    @regions = Region.includes(:prefectures, :cities).all
  end

  private

  def trainer_profile_params
    params.require(:trainer).permit(
      :name, :age,
      :introduction,
      :min_fee, :instruction_period,
      :category, :instruction_method, :avatar,
      city_ids: [], day_of_week_ids: []
    )
  end

  def trainer_search_params
    params.fetch(:search_trainer, {}).permit(
      :age_from, :age_to,
      :gender,
      :category,
      :instruction_method,
      :instruction_period,
      :min_fee_from, :min_fee_to,
      city_ids: [], day_of_week_ids: []
    )
  end

  def check_current_trainer
    if current_trainer.nil?
      flash[:notice] = "ログインもしくはアカウント登録してください。"
      redirect_to root_path
    elsif current_trainer.id.to_s != params[:id]
      flash[:notice] = "他ユーザーのプロフィールは変更できません。"
      redirect_to trainer_path(current_trainer)
    end
  end

  def check_for_searching_trainer
    if current_trainer.present?
      flash[:notice] = "トレーナー検索を利用できるのはトレーニーユーザーのみです。"
      redirect_to root_path
    elsif current_trainee.nil?
      flash[:notice] = "トレーニーとしてログインもしくはアカウント登録してください。"
      redirect_to new_trainee_session_path
    end
  end
end
