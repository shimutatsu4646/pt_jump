require 'rails_helper'

RSpec.describe "Trainer Registration Request", type: :request do
  describe "GET /trainers/sign_up" do
    context "ゲストユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        get new_trainer_registration_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "ログイン済みのトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      it "302レスポンスを返し、トップページにリダイレクトすること" do
        sign_in trainer
        get new_trainer_registration_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "POST /trainers" do
    context "有効な属性値の場合" do
      it "トレーナーの新規登録ができること" do
        trainer_create_params = attributes_for(:trainer)
        expect do
          post "/trainers", params: { trainer: trainer_create_params }
        end.to change { Trainer.count }.by(1)
      end
    end

    context "無効な属性値の場合" do
      it "トレーナーの新規登録ができないこと" do
        false_trainer_params = attributes_for(:trainer, name: nil)
        expect do
          post "/trainers", params: { trainer: false_trainer_params }
        end.not_to change { Trainer.count }
      end
    end
  end

  describe "GET /trainers/edit" do
    context "認可されたトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      it "正常にレスポンスを返すこと" do
        sign_in trainer
        get edit_trainer_registration_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、ログインページにリダイレクトすること" do
        get edit_trainer_registration_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainer_session_path
        end
      end
    end
  end

  describe "PATCH /trainers" do
    context "認可されたトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      it "アカウントを更新し、詳細ページにリダイレクトすること" do
        trainer_update_params = {
          email: "update_email@example.com",
          current_password: "trainer_password"
        }
        sign_in trainer
        patch trainer_registration_path, params: { id: trainer.id, trainer: trainer_update_params }
        aggregate_failures do
          expect(trainer.reload.email).to eq "update_email@example.com"
          expect(response).to redirect_to trainer_path(trainer.id)
        end
      end
    end

    context "認可されていないトレーナーの場合" do
      let(:trainer) { create(:trainer, email: "before_update@example.com") }
      let(:other_trainer) { create(:trainer) }

      it "対象のトレーナーを更新できないこと" do
        trainer_update_params = {
          email: "update_email@example.com",
          current_password: "trainer_password"
        }
        sign_in other_trainer
        patch trainer_registration_path, params: { id: trainer.id, trainer: trainer_update_params }
        aggregate_failures do
          expect(trainer.reload.email).to eq "before_update@example.com"
          expect(response).to redirect_to trainer_path(other_trainer.id)
        end
      end
    end

    context "ゲストユーザーの場合" do
      let(:trainer) { create(:trainer) }

      it "302レスポンスを返し、サインインページにリダイレクトすること" do
        trainer_update_params = {
          email: "update_email@example.com",
          current_password: "trainer_password"
        }
        patch trainer_registration_path, params: { id: trainer.id, trainer: trainer_update_params }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainer_session_path
        end
      end
    end
  end

  describe "DELETE /trainers" do
    let(:trainee) { create(:trainee) }
    let(:trainer) { create(:trainer) }

    let!(:candidate) do
      create(:candidate, trainee_id: trainee.id, trainer_id: trainer.id)
    end

    let!(:chat) do
      create(:chat,
        trainee_id: trainee.id, trainer_id: trainer.id,
        content: "hello.", from_trainee: true)
    end

    let!(:contract) do
      create(:contract, trainee_id: trainee.id, trainer_id: trainer.id, final_decision: false)
    end

    before do
      sign_in trainer
    end

    scenario "正常にレスポンスを返すこと" do
      expect do
        delete trainer_registration_path
      end.to change { Trainer.count }.by(-1)
      expect(response).to redirect_to root_path
    end
  end
end
