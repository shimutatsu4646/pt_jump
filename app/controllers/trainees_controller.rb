class TraineesController < ApplicationController
  before_action :check_current_trainee, only: [:edit, :update]

  def show
    @trainee = Trainee.find(params[:id])
  end

  def edit
    @trainee = current_trainee
  end

  def update
    @trainee = current_trainee
    if @trainee.update(trainee_profile_params)
      flash[:notice] = "プロフィール情報を変更しました。"
      redirect_to trainee_path(@trainee)
    else
      render :edit
    end
  end

  private

  def trainee_profile_params
    params.require(:trainee).permit(:name, :age, :gender, :introduction, :timeframe,
      :dm_allowed, :category, :instruction_method, :avatar)
  end

  def check_current_trainee
    if current_trainee.nil?
      flash[:notice] = "ログインもしくはアカウント登録してください。"
      redirect_to root_path
    elsif current_trainee.id.to_s != params[:id]
      flash[:notice] = "他ユーザーのプロフィールは変更できません。"
      redirect_to trainee_path(current_trainee)
    end
  end
end
