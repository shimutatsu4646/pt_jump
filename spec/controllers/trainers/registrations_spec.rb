require 'rails_helper'

RSpec.describe Trainers::RegistrationsController, type: :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:trainer]
  end

  describe "#new" do
    context "ゲストユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        get :new
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
        get :new
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "#create" do
    context "有効な属性値の場合" do
      it "トレーナーの新規登録ができること" do
        trainer_create_params = attributes_for(:trainer)
        expect do
          post :create, params: { trainer: trainer_create_params }
        end.to change { Trainer.count }.by(1)
      end
    end

    context "無効な属性値の場合" do
      it "トレーナーの新規登録ができないこと" do
        false_trainer_params = attributes_for(:trainer, name: nil)
        expect do
          post :create, params: { trainer: false_trainer_params }
        end.not_to change { Trainer.count }
      end
    end
  end

  describe "#edit" do
    context "認可されたトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      it "正常にレスポンスを返すこと" do
        sign_in trainer
        get :edit
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、ログインページにリダイレクトすること" do
        get :edit
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainer_session_path
        end
      end
    end
  end

  describe "#update" do
    context "認可されたトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      it "アカウントを変更し、詳細ページにリダイレクトすること" do
        trainer_update_params = {
          email: "update_email@example.com",
          current_password: "trainer_password"
        }
        sign_in trainer
        patch :update, params: { id: trainer.id, trainer: trainer_update_params }
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
        patch :update, params: { id: trainer.id, trainer: trainer_update_params }
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
        patch :update, params: { id: trainer.id, trainer: trainer_update_params }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainer_session_path
        end
      end
    end
  end
end
