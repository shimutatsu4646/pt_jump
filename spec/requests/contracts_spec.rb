require 'rails_helper'

RSpec.describe "Contracts Request", type: :request do
  describe "GET /contracts" do # index
    let(:trainee) { create(:trainee) }
    let(:trainer) { create(:trainer) }

    context "トレーニーとしてログインしている場合" do
      it "正常にレスポンスを返すこと" do
        sign_in trainee
        get contracts_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      it "正常にレスポンスを返すこと" do
        sign_in trainer
        get contracts_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、トップページにリダイレクトすること" do
        get contracts_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "GET /contracts/:id" do # show
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }
      let(:contract) { create(:contract, trainee_id: trainee.id, trainer_id: trainer.id) }

      it "urlのidが契約のidと一致するとき正常にレスポンスを返すこと" do
        sign_in trainee
        get "/contracts/#{contract.id}"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end

      it "urlのidが契約のidと一致しないとき404レスポンスを返すこと" do
        sign_in trainee
        get "/contracts/#{contract.id + 1}"
        expect(response).to have_http_status(404)
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }
      let(:contract) { create(:contract, trainee_id: trainee.id, trainer_id: trainer.id) }

      it "urlのidが契約のidと一致するとき正常にレスポンスを返すこと" do
        sign_in trainer
        get "/contracts/#{contract.id}"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end

      it "urlのidが契約のidと一致しないとき404レスポンスを返すこと" do
        sign_in trainer
        get "/contracts/#{contract.id + 1}"
        expect(response).to have_http_status(404)
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }
      let(:contract) { create(:contract, trainee_id: trainee.id, trainer_id: trainer.id) }

      it "302レスポンスを返し、トップページにリダイレクトすること" do
        get "/contracts/#{contract.id}"
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "GET /contracts/new/:id" do # new
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      it "urlのidにidが一致するトレーナーが存在する場合、正常にレスポンスを返すこと" do
        sign_in trainee
        get "/contracts/new/#{trainer.id}"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end

      it "urlのidにidが一致するトレーナーが存在しない場合、404レスポンスを返すこと" do
        sign_in trainee
        get "/contracts/new/#{trainer.id + 1}"
        expect(response).to have_http_status(404)
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      it "302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        sign_in trainer
        get "/contracts/new/#{trainer.id}"
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }

      it "302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        get "/contracts/new/#{trainer.id}"
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end

  describe "POST /contracts" do # create
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      it "入力値に問題がない場合、契約を生成し、契約一覧ページにリダイレクトすること" do
        sign_in trainee
        create_contract_params = {
          trainee_id: trainee.id,
          trainer_id: trainer.id,
          start_date: Date.current,
          end_date: Date.current + 30,
          final_decision: false
        }
        expect do
          post contracts_path, params: { contract: create_contract_params }
        end.to change { Contract.count }.by(1)
        expect(response).to redirect_to contracts_path
      end

      it "入力値に問題がある場合、契約は生成されず、302レスポンスを返し、契約リクエストページにリダイレクトされること" do
        sign_in trainee
        create_contract_params = {
          trainee_id: trainee.id,
          trainer_id: trainer.id,
          start_date: nil,
          end_date: nil,
          final_decision: false
        }
        expect do
          post contracts_path, params: { contract: create_contract_params }
        end.not_to change { Contract.count }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_contract_path(trainer.id)
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      it "契約は生成されず、302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        sign_in trainer
        create_contract_params = {
          trainee_id: trainee.id,
          trainer_id: trainer.id,
          start_date: Date.current,
          end_date: Date.current + 30,
          final_decision: false
        }
        expect do
          post contracts_path, params: { contract: create_contract_params }
        end.not_to change { Contract.count }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }

      it "契約は生成されず、302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        create_contract_params = {
          trainee_id: trainee.id,
          trainer_id: trainer.id,
          start_date: Date.current,
          end_date: Date.current + 30,
          final_decision: false
        }
        expect do
          post contracts_path, params: { contract: create_contract_params }
        end.not_to change { Contract.count }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end

  describe "PATCH /contracts/:id" do # update
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      let!(:contract) do
        create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
      end

      it "契約は更新されず、302レスポンスを返し、トレーナーログインページにリダイレクトすること" do
        sign_in trainee
        patch contract_path(contract.id)
        aggregate_failures do
          expect(contract.reload.final_decision).to eq false
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainer_session_path
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      let!(:contract) do
        create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
      end

      it "契約が更新され（final_decisionがtrueとなる）、契約一覧ページにリダイレクトすること" do
        sign_in trainer
        patch contract_path(contract.id)
        aggregate_failures do
          expect(contract.reload.final_decision).to eq true
          expect(response).to redirect_to contracts_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }

      let!(:contract) do
        create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
      end

      it "契約は更新されず、302レスポンスを返し、トレーナーログインページにリダイレクトすること" do
        patch contract_path(contract.id)
        aggregate_failures do
          expect(contract.reload.final_decision).to eq false
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainer_session_path
        end
      end
    end
  end

  describe "DELETE /contracts/:id" do # destroy
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      context "契約のfinal_decisionがfalseの場合" do
        let!(:contract) do
          create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
        end

        it "契約が削除され、契約一覧ページにリダイレクトすること" do
          sign_in trainee
          expect do
            delete contract_path(contract.id)
          end.to change { Contract.count }.by(-1)
          expect(response).to redirect_to contracts_path
        end
      end

      context "契約のfinal_decisionがtrueの場合" do
        let!(:contract) do
          create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: true)
        end

        it "契約は削除されず、契約詳細ページにリダイレクトすること" do
          sign_in trainee
          expect do
            delete contract_path(contract.id)
          end.not_to change { Contract.count }
          aggregate_failures do
            expect(response).to have_http_status "302"
            expect(response).to redirect_to contract_path(contract.id)
          end
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }
      let(:trainer) { create(:trainer) }

      let!(:contract) do
        create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
      end

      it "契約は削除されず、302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        sign_in trainer
        expect do
          delete contract_path(contract.id)
        end.not_to change { Contract.count }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end

    context "ゲストユーザーの場合" do
      let!(:trainee) { create(:trainee) }
      let!(:trainer) { create(:trainer) }

      let!(:contract) do
        create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
      end

      it "契約は削除されず、302レスポンスを返し、トレーニーログインページにリダイレクトすること" do
        expect do
          delete contract_path(contract.id)
        end.not_to change { Contract.count }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end
end
