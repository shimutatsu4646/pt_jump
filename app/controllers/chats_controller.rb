class ChatsController < ApplicationController
  before_action :signed_in?

  def index
    if trainee_signed_in?
      @my_chats = current_trainee.chats.includes(:trainer)
      trainer_ids = []
      @my_chats.each do |chat|
        trainer_ids << chat.trainer_id
      end
      trainer_ids.uniq
      # ↑自分(trainee)と関連付いているチャットに、関連付けられたtrainerのidを全て取得し、一意にする。
      @chat_partners = Trainer.includes(:chats).
        with_attached_avatar.
        where(chats: { trainer_id: trainer_ids }).
        order("chats.created_at DESC")
    elsif trainer_signed_in?
      @my_chats = current_trainer.chats.includes(:trainer)
      trainee_ids = []
      @my_chats.each do |chat|
        trainee_ids << chat.trainee_id
      end
      trainee_ids.uniq
      # ↑自分(trainer)と関連付いているチャットに、関連付けられたtraineeのidを全て取得し、一意にする。
      @chat_partners = Trainee.includes(:chats).
        with_attached_avatar.
        where(chats: { trainee_id: trainee_ids }).
        order("chats.created_at DESC")

    end
  end

  def show
    if trainee_signed_in?
      @partner = Trainer.with_attached_avatar.find(params[:id])
      @chats_by_myself = Chat.where(trainee_id: current_trainee.id, trainer_id: @partner.id, from_trainee: true)
      @chats_by_other = Chat.where(trainee_id: current_trainee.id, trainer_id: @partner.id, from_trainee: false)
      @chats = @chats_by_myself.or(@chats_by_other)
      @chats = @chats.order(:created_at)
    elsif trainer_signed_in?
      @partner = Trainee.with_attached_avatar.find(params[:id])
      @chats_by_myself = Chat.where(trainee_id: @partner.id, trainer_id: current_trainer.id, from_trainee: false)
      @chats_by_other = Chat.where(trainee_id: @partner.id, trainer_id: current_trainer.id, from_trainee: true)
      @chats = @chats_by_myself.or(@chats_by_other)
      @chats = @chats.order(:created_at)
    end

    @chat = Chat.new # チャット入力フォームに利用するインスタンス
  end

  def create
    if trainee_signed_in?
      @partner = Trainer.find_by(id: params[:chat][:partner_id])
    elsif trainer_signed_in?
      @partner = Trainee.find_by(id: params[:chat][:partner_id])
    end

    @chat = Chat.new(chat_params)
    if @chat.save
      redirect_to chat_path(@partner)
    else
      redirect_to chat_path(@partner)
      flash[:notice] = "何か入力してください"
    end
  end

  private

  def signed_in?
    if trainee_signed_in? == false && trainer_signed_in? == false
      redirect_to root_path
      flash[:notice] = "チャット機能はログインしていないと利用できません。"
    end
  end

  def chat_params
    if trainee_signed_in?
      params.require(:chat).permit(:content).merge(
        trainee_id: current_trainee.id,
        trainer_id: @partner.id,
        from_trainee: true
      )
    elsif trainer_signed_in?
      params.require(:chat).permit(:content).merge(
        trainee_id: @partner.id,
        trainer_id: current_trainer.id,
        from_trainee: false
      )
    end
  end
end
