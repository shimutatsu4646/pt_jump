require 'rails_helper'

RSpec.describe Trainees::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:trainee]
  end

  describe "#new" do
    context "ログイン済みのトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      it "302レスポンスを返すこと" do
        sign_in trainee
        get :new
        expect(response).to have_http_status "302"
      end
    end

    context "ログインしていないトレーニーの場合" do
      let(:trainee) { create(:trainee) }

      it "200レスポンスを返すこと" do
        get :new
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#create" do
    context "送信したEメール・パスワードに一致するトレーニーが存在する場合" do
      let(:trainee) { create(:trainee) }

      it "ログインし、トップページにリダイレクトすること" do
        session_params = { email: trainee.email, password: trainee.password }
        aggregate_failures do
          expect do
            post :create, params: { trainee: session_params }
          end.to change { @controller.current_trainee }.from(nil).to(trainee)
          expect(response).to redirect_to root_path
        end
      end
    end

    context "送信したEメール・パスワードに一致するトレーニーが存在しない場合" do
      !let(:trainee) { create(:trainee) }

      it "ログインできず、ログインページにレンダリングすること" do
        session_params = { email: "not_owned_email@example.com", password: "not_owned_password" }
        post :create, params: { trainee: session_params }
        aggregate_failures do
          expect(@controller.current_trainee).to eq nil
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "#destroy" do
    let(:trainee) { create(:trainee) }

    it "ログアウトすること" do
      sign_in trainee
      expect do
        delete :destroy
      end.to change { @controller.current_trainee }.from(trainee).to(nil)
    end
  end
end
