require 'rails_helper'

RSpec.describe Trainers::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:trainer]
  end

  describe "#new" do
    context "ログイン済みのトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      it "302レスポンスを返すこと" do
        sign_in trainer
        get :new
        expect(response).to have_http_status "302"
      end
    end

    context "ログインしていないトレーナーの場合" do
      let(:trainer) { create(:trainer) }

      it "200レスポンスを返すこと" do
        get :new
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#create" do
    context "送信したEメール・パスワードに一致するトレーナーが存在する場合" do
      let(:trainer) { create(:trainer) }

      it "ログインし、トップページにリダイレクトすること" do
        session_params = { email: trainer.email, password: trainer.password }
        aggregate_failures do
          expect do
            post :create, params: { trainer: session_params }
          end.to change { @controller.current_trainer }.from(nil).to(trainer)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "送信したEメール・パスワードに一致するトレーナーが存在しない場合" do
      !let(:trainer) { create(:trainer) }

      it "ログインできず、ログインページにレンダリングすること" do
        session_params = { email: "not_owned_email@example.com", password: "not_owned_password" }
        post :create, params: { trainer: session_params }
        aggregate_failures do
          expect(@controller.current_trainer).to eq nil
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "#destroy" do
    let(:trainer) { create(:trainer) }

    it "ログアウトすること" do
      sign_in trainer
      expect do
        delete :destroy
      end.to change { @controller.current_trainer }.from(trainer).to(nil)
    end
  end
end
