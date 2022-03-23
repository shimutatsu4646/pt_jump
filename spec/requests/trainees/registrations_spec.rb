require 'rails_helper'

RSpec.describe "Trainee Registration Request", type: :request do
  describe "GET /trainees/sign_up" do
    context "ゲストユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        get new_trainee_registration_path
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
        get new_trainee_registration_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "POST /trainees" do
    context "有効な属性値の場合" do
      it "トレーニーの新規登録ができること" do
        trainee_create_params = attributes_for(:trainee)
        expect do
          post "/trainees", params: { trainee: trainee_create_params }
        end.to change { Trainee.count }.by(1)
      end
    end

    context "無効な属性値の場合" do
      it "トレーニーの新規登録ができないこと" do
        false_trainee_params = attributes_for(:trainee, name: nil)
        expect do
          post "/trainees", params: { trainee: false_trainee_params }
        end.not_to change { Trainee.count }
      end
    end
  end

  describe "GET /trainees/edit" do
    context "認可されたトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      it "正常にレスポンスを返すこと" do
        sign_in trainee
        get edit_trainee_registration_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "302レスポンスを返し、ログインページにリダイレクトすること" do
        get edit_trainee_registration_path
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end

  describe "PATCH /trainees" do
    context "認可されたトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      it "アカウントを更新し、詳細ページにリダイレクトすること" do
        trainee_update_params = {
          email: "update_email@example.com",
          current_password: "trainee_password"
        }
        sign_in trainee
        patch trainee_registration_path, params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(trainee.reload.email).to eq "update_email@example.com"
          expect(response).to redirect_to trainee_path(trainee.id)
        end
      end
    end

    context "認可されていないトレーニーの場合" do
      let(:trainee) { create(:trainee, email: "before_update@example.com") }
      let(:other_trainee) { create(:trainee) }

      it "対象のトレーニーを更新できないこと" do
        trainee_update_params = {
          email: "update_email@example.com",
          current_password: "trainee_password"
        }
        sign_in other_trainee
        patch trainee_registration_path, params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(trainee.reload.email).to eq "before_update@example.com"
          expect(response).to redirect_to trainee_path(other_trainee.id)
        end
      end
    end

    context "ゲストユーザーの場合" do
      let(:trainee) { create(:trainee) }

      it "302レスポンスを返し、サインインページにリダイレクトすること" do
        trainee_update_params = {
          email: "update_email@example.com",
          current_password: "trainee_password"
        }
        patch trainee_registration_path, params: { id: trainee.id, trainee: trainee_update_params }
        aggregate_failures do
          expect(response).to have_http_status "302"
          expect(response).to redirect_to new_trainee_session_path
        end
      end
    end
  end
end
