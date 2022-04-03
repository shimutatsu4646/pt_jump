class TraineesController < ApplicationController
  before_action :check_current_trainee, only: [:edit, :update]
  before_action :check_for_searching_trainee, only: [:search]

  def show
    @trainee = Trainee.includes(:prefectures, :cities, :day_of_weeks).with_attached_avatar.find(params[:id])
  end

  def edit
    @trainee = current_trainee
    @regions = Region.includes(:prefectures, :cities).all
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

  def search
    @trainee_search_params = trainee_search_params
    @trainees = Trainee.includes(:prefectures, :cities, :day_of_weeks).with_attached_avatar.search_trainee(@trainee_search_params)
    @regions = Region.includes(:prefectures, :cities).all
  end

  private

  def trainee_profile_params
    params.require(:trainee).permit(
      :name, :age,
      :introduction,
      :chat_acceptance, :category,
      :instruction_method, :avatar,
      city_ids: [], day_of_week_ids: []
    )
  end

  def trainee_search_params
    params.fetch(:search_trainee, {}).permit(
      :age_from, :age_to,
      :chat_acceptance,
      :gender,
      :category,
      :instruction_method,
      city_ids: [], day_of_week_ids: []
    )
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

  def check_for_searching_trainee
    if current_trainee.present?
      flash[:notice] = "トレー二ー検索を利用できるのはトレーナーユーザーのみです。"
      redirect_to root_path
    elsif current_trainer.nil?
      flash[:notice] = "トレーナーとしてログインもしくはアカウント登録してください。"
      redirect_to new_trainer_session_path
    end
  end
end
