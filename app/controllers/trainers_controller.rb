class TrainersController < ApplicationController
  before_action :check_current_trainer, only: [:edit, :update]

  def show
    @trainer = Trainer.find(params[:id])
  end

  def edit
    @trainer = current_trainer
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

  private

  def trainer_profile_params
    params.require(:trainer).permit(
      :name, :age, :gender,
      :introduction, :timeframe,
      :min_fee, :max_fee, :instruction_period,
      :category, :instruction_method, :avatar,
      city_ids: []
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
end
