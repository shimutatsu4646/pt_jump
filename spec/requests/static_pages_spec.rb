require 'rails_helper'

RSpec.describe "StaticPages Request", type: :request do
  describe "GET /" do
    context "トレーニーとしてログインしている場合" do
      let(:trainee) { create(:trainee) }

      it "正常にレスポンスを返すこと" do
        sign_in trainee
        get "/"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "トレーナーとしてログインしている場合" do
      let(:trainer) { create(:trainer) }

      it "正常にレスポンスを返すこと" do
        sign_in trainer
        get "/"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end

    context "ゲストユーザーの場合" do
      it "正常にレスポンスを返すこと" do
        get "/"
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end
    end
  end
end
