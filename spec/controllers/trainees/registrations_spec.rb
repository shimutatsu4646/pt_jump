require 'rails_helper'

RSpec.describe Trainees::RegistrationsController, type: :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:trainee]
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

    context "ログイン済みのトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      it "302レスポンスを返し、トップページにリダイレクトすること" do
        sign_in trainee
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
      it "トレーニーの新規登録ができること" do
        trainee_create_params = attributes_for(:trainee)
        expect do
          post :create, params: { trainee: trainee_create_params }
        end.to change { Trainee.count }.by(1)
      end
    end

    context "無効な属性値の場合" do
      it "トレーニーの新規登録ができないこと" do
        false_trainee_params = attributes_for(:trainee, name: nil)
        expect do
          post :create, params: { trainee: false_trainee_params }
        end.not_to change { Trainee.count }
      end
    end
  end

  describe "#edit" do
    context "認可されたトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      it "正常にレスポンスを返すこと" do
        sign_in trainee
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
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end

  describe "#update" do
    context "認可されたトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      it "アカウントを変更し、詳細ページにリダイレクトすること" do
        trainee_update_params = attributes_for(:trainee,
          name: "trainee_after_update",
          current_password: "trainee_password")
        sign_in trainee
        patch :update, params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(trainee.reload.name).to eq "trainee_after_update"
          expect(response).to redirect_to trainee_path(trainee.id)
        end
      end
    end

    context "認可されていないトレーニーの場合" do
      let(:trainee) { create(:trainee, name: "trainee_before_update") }
      let(:other_trainee) { create(:trainee) }

      it "対象のトレーニーを更新できないこと" do
        trainee_update_params = attributes_for(:trainee,
          name: "trainee_after_update",
          current_password: "trainee_password")
        sign_in other_trainee
        patch :update, params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(trainee.reload.name).to eq "trainee_before_update"
          expect(response).to redirect_to trainee_path(other_trainee.id)
        end
      end
    end

    context "ゲストユーザーの場合" do
      let(:trainee) { create(:trainee) }

      it "302レスポンスを返し、サインインページにリダイレクトすること" do
        trainee_update_params = attributes_for(:trainee,
          name: "trainee_after_update",
          current_password: "trainee_password")
        patch :update, params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end
end
