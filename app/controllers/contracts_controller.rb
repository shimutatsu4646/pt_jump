class ContractsController < ApplicationController
  before_action :authenticate_trainee!, only: [:new, :create, :destroy]
  before_action :authenticate_trainer!, only: [:update]
  before_action :signed_in?, only: [:index, :show]

  def index
    if trainee_signed_in?
      @undecided_contracts = Contract.
        where(trainee_id: current_trainee.id, final_decision: false).
        order("contracts.created_at DESC")
      @decided_contracts = Contract.
        where(trainee_id: current_trainee.id, final_decision: true).
        order("contracts.updated_at DESC")
    elsif trainer_signed_in?
      @undecided_contracts = Contract.
        where(trainer_id: current_trainer.id, final_decision: false).
        order("contracts.created_at DESC")
      @decided_contracts = Contract.
        where(trainer_id: current_trainer.id, final_decision: true).
        order("contracts.updated_at DESC")
    end
  end

  def show
    @contract = Contract.find(params[:id])
  end

  def new
    @trainer  = Trainer.find(params[:id])
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_create_params)
    trainer = Trainer.find(@contract.trainer_id)

    if @contract.save
      redirect_to contracts_path
      flash[:notice] = "#{trainer.name} さんに契約リクエストをしました。"
    else
      # トレーナーのidを渡すためrenderではなく、redirect_toとした。
      redirect_to new_contract_path(trainer.id)
      flash[:notice] = "指導の開始日または終了日の入力に問題があったため、契約リクエストに失敗しました。"
    end
  end

  def update
    contract = Contract.find(params[:id])

    if contract.trainer == current_trainer
      # final_decisionをtrueにする。契約が成立したことを表す。
      contract.update!(final_decision: true)
      flash[:notice] = "契約成立しました。"
      redirect_to contracts_path
    else
      redirect_to trainer_path(current_trainer)
    end
  end

  def destroy
    contract = Contract.find(params[:id])
    if contract.final_decision == true
      redirect_to contract_path(contract.id)
      flash[:notice] = "成立済みの契約は取り消せません。"
    elsif contract.trainee == current_trainee
      contract.destroy
      redirect_to contracts_path
      flash[:notice] = "契約リクエストを取り消しました。"
    end
  end

  private

  def signed_in?
    if trainee_signed_in? == false && trainer_signed_in? == false
      redirect_to root_path
      flash[:notice] = "ログインしていないと閲覧できません。"
    end
  end

  def contract_create_params
    params.require(:contract).permit(:trainer_id, :trainee_id, :start_date, :end_date).merge(
      final_decision: false # 契約はまだ成立していないことを表す
    )
  end
end
